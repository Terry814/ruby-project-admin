class UserMailer < ActionMailer::Base
  def previews_links_email(user)
    mail subject: "Download the AppEase Previews App", to: user.email
  end

  def instant_download_link_email(user, download_link)
    @app_name = user.application_info.app_stores_info.ios_app_name || user.company_name
    @download_link = download_link
    @user = user
    subject = if user.sign_up_method == 'admin'
      "Mobile App for #{@app_name}"
    else
      "Preview Your Mobile App"
    end
    mail subject: subject, to: user.email, bcc: ENV['ADMIN_EMAIL']
  end
end
