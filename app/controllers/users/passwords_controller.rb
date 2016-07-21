class Users::PasswordsController < Devise::PasswordsController
  def create
    super do |resource|
      @from_password_reset = true
      render "devise/sessions/new"
      return
    end
  end

  def update
    super do |user|
      user.update(last_changed_password_at: DateTime.current)
      report_event user
    end
  end

  private

  def report_event user
    change = user.previous_changes['last_changed_password_at']
    return if change.blank?
    if user.sign_up_method == 'admin' && change.first.blank? && change.last.present?
      create_intercom_event(
        event_name: 'user-claimed-account',
        created_at: Time.now.to_i,
        user_id: user.id,
      )
    end
  end
end