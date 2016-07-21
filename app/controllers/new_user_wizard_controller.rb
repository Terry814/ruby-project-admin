class NewUserWizardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company_info, only: [:wizard, :companies, :set_company]

  after_action -> { report_event 'searched-companies', company_info_params }, only: :companies
  after_action -> { report_event 'selected-company', 
                      {'4sq Link' => "https://foursquare.com/v/#{params[:venue_id]}"} },
                  only: :set_company
  after_action -> { report_event 'skipped-company-search' }, only: :step_two,
                  if: proc { params[:from_skip] == 'true' }
  after_action -> { report_event 'selected-plan', {plan: current_user.plan_name} },
                  only: :step_three,
                  if: proc { params[:from_plans] == 'true' }
  after_action -> { report_event 'skipped-billing-info' }, only: :step_four,
                  if: proc { params[:from_skip] == 'true' }
  after_action -> { report_event 'finished-new-user-wizard' }, only: :step_four_done

  STEPS = [
    'Tell Us About Your Business',
    'Select Your Package',
    'Add Your Billing Info',
    'Now, Sit Back and Relax'
    ]

  def wizard
    render_step 1
  end

  def companies
    @company_info.assign_attributes(company_info_params)
    if @company_info.valid?
      res = Foursquare::Client.search_venues(@company_info.name, @company_info.full_address)
      if res.ok?
        if res.data.empty?
          t_flash :alert, '.not_found', true
        else
          @companies = res.data
        end
      else
        flash.now[:error] = res.error
      end
    end
    respond_to do |format|
      format.html { render 'steps', locals: {current_step: 1} }
      format.js
    end
  end

  def set_company
    venue_id = params[:venue_id]
    @company_info.assign_attributes(company_info_params)
    res = Foursquare::Client.get_venue venue_id
    @company_info.venue_data = res.data if res.ok?
    populate_data @company_info
    redirect_to action: :step_two, format: request.format.symbol
  end

  def step_two
    render_step 2
  end

  def step_two_done
    render_step 2
  end

  def step_three
    @billing_info = current_user.billing_info || current_user.build_billing_info
    render_step 3
  end

  def step_four
    render_step 4
  end

  def step_four_done
    respond_to do |format|
      format.html { redirect_to home_path_with_company_name }
      format.js
    end
  end

  private

  def render_step step
    respond_to do |format|
      format.html { render 'wizard/steps', locals: {steps: STEPS, current_step: step} }
      format.js { render 'wizard/present_step', locals: {current_step: step} }
    end
  end

  def set_company_info
    @company_info = CompanyInfo.new(name: current_user.company_name)
  end

  def company_info_params
    params.require(:company_info).permit(:name, :web_link, :street, :city, :state, :postal_code)
  end

  def populate_data company_info
    ApplicationPopulateJob.new.async.perform(company_info, current_application)
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