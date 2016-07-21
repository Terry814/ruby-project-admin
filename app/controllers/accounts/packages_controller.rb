class Accounts::PackagesController < Accounts::BaseController
  after_action :report_event, only: :update

  def update
    current_user.current_package = params[:package].to_i
    current_user.save!
    @current_ability = nil
    @current_user = nil
    current_application.adjust_menu_items_for_package
    if params[:redirect_to].present?
      redirect_to params[:redirect_to], format: request.format.symbol
    else
      respond_to do |format|
        format.html { redirect_to action: :show }
        format.js
      end
    end
  end

  private

  def report_event
    change = current_user.previous_changes['current_package']
    return if change.blank?

    create_intercom_event(
      event_name: 'changed-plan',
      created_at: Time.now.to_i,
      user_id: current_user.id,
      metadata: {
        from: User.plan_name_for(change.first),
        to: User.plan_name_for(change.last)
      }
    )
    create_intercom_user(
      user_id: current_user.id,
      custom_attributes: {
        package: current_user.plan_name
      }
    )
  end
end
