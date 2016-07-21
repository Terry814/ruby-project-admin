class AdminMailer < ActionMailer::Base
  default to: Rails.env.production? ? ENV['ADMIN_EMAIL'] : ENV['DEVELOPER_EMAIL']

  def addon_purchase_email(user, addon, charge)
    @user = user
    @addon = addon
    @charge = charge
    env = Rails.env.production? ? '' : 'test/'
    @customer_email = "https://dashboard.stripe.com/#{env}customers/#{charge.customer}"
    @charge_url = "https://dashboard.stripe.com/#{env}payments/#{charge.id}"
    mail subject: "New addon purchase"
  end

  def exception_email(exception, context = nil, user = nil)
    puts 'Exception email'
    return unless Rails.env.production? || Rails.env.staging?
    @e = exception
    @context = context
    @user = user
    mail subject: "Exception in app", to: ENV['DEVELOPER_EMAIL']
  end

  def user_details_email user, subject
    @user = user
    mail subject: subject
  end
end
