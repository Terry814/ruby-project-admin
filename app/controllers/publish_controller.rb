class PublishController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_billing_info!, only: [:step_two, :step_three]

  after_action -> { report_event 'presented-publish-wizard',
                      { last_published_date: current_user.last_published_at.to_i,
                        ready_to_publish: current_user.ready_to_publish?.to_s,
                        needs_publish: current_user.needs_publish?.to_s }
                    }, only: :step_one
  after_action -> { report_event 'presented-preview-links' }, only: :step_two
  after_action -> { report_event 'emailed-preview-links' }, only: :email_preview_links
  after_action -> { report_event 'requested-publishing',
                      {last_published_date: current_user.last_published_at.to_i} },
                  only: :publish,
                  if: proc { params[:approve] == '1' }

  STEPS = [ 'Get Ready to Publish', 'Preview Your App', 'Publish!' ]

  def step_one
    render_step 1
  end

  def step_one_done
    if current_user.needs_publish?
      if current_user.ready_to_publish?
        redirect_to(action: :step_two, format: request.format.symbol) and return
      else
        flash.now[:notice] = view_context.not_ready_message
      end
    else
      flash.now[:notice] = view_context.everything_up_to_date
    end
    render_step 1
  end

  def step_two
    render_step 2
  end

  def email_preview_links
    UserMailer.previews_links_email(current_user).deliver
    flash.now[:success] = "Email successfully sent"
    respond_to do |format|
      format.html { render 'steps', locals: {current_step: 2} }
      format.js { head :ok }
    end
  end

  def step_three
    render_step 3
  end

  def publish
    if params[:approve] != '1'
      flash[:alert] = "Please approve app publishing"
      render_step(3) and return
    end
    AdminMailer.user_details_email(current_user, "New publish request").deliver
    flash[:success] = view_context.publish_pending
    current_application.touch(:last_published_at)
    redirect_to_home
  end

  private

  def render_step step
    respond_to do |format|
      format.html { render 'wizard/steps', locals: {steps: STEPS, current_step: step} }
      format.js { render 'wizard/present_step', locals: {current_step: step} }
    end
  end

  def report_event name, metadata = {}
    create_intercom_event(
      event_name: name,
      created_at: Time.now.to_i,
      user_id: current_user.id,
      metadata: metadata
    )
  end
end