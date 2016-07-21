module IntercomHelper
  include RealUserHelper

  def create_intercom_user_from_user user
    create_intercom_user(intercom_attributes(user))
  end

  def create_intercom_user options
    IntercomUserCreateJob.new.async.perform(options)
  end

  def create_intercom_event options
    return if original_user && original_user.admin?
    IntercomEventJob.new.async.perform(options)
  end

  private

  def intercom_attributes user
    {
      user_id: user.id,
      email: user.email,
      name: user.full_name,
      signed_up_at: user.created_at,
      unsubscribed_from_emails: !user.subscribed_to_emails,
      custom_attributes: {
        package: user.plan_name,
        last_published_at: user.last_published_at,
        sign_up_method: user.sign_up_method
      }.compact
    }.compact
  end
end