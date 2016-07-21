class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  layout :resolve_layout

  respond_to :js, :html

  def update
    super do |user|
      report_event user
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:full_name, :company_name, :terms, :phone_number)
    devise_parameter_sanitizer.for(:account_update).push(:full_name, :company_name, :phone_number, :subscribed_to_emails)
  end

  def after_sign_up_path_for(resource)
    resource.plain? ? new_user_wizard_path : home_path_with_company_name
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def resolve_layout
    return 'devise' unless user_signed_in?
    pjax_request? ? 'application_container' : 'application'
  end

  def report_event user
    change = user.previous_changes
    change.slice!('email', 'full_name', 'subscribed_to_emails')
    return if change.blank?

    create_intercom_user_from_user user
    create_intercom_event(
      event_name: 'updated-account-details',
      created_at: Time.now.to_i,
      user_id: user.id,
      metadata: metadata_hash_with(change)
    )
  end

  def metadata_hash_with change
    result = {}
    change.each do |atrb, change_arr|
      result["old_#{atrb}"] = change_arr.first.to_s
      result["new_#{atrb}"] = change_arr.last.to_s
    end
    result
  end
end
