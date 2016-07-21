class DeviseMailer < Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    mail = super
    if record.took_ownership?
      mail.subject = 'Reset password instructions'
    else
      mail.subject =  'Can I ask you something?'
      mail.from = 'Patty Aleman <patty@getappease.com>'
    end
    mail
  end
end