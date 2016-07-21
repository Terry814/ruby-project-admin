module PublishHelper
  def not_ready_message
    status_link = link_to 'App Status', home_path_with_company_name
    let_us_know_link = mail_to 'service@getappease.com', 'let us know'
    "We're sorry but you still have a few steps to complete before you can publish. Head over to #{status_link} to see the remaining action items, and #{let_us_know_link} if you need our help.".html_safe
  end

  def everything_up_to_date
    "Everything for your app is published and up to date! Please note that most of the changes you make on AppEase are effective immediately in your app. To see changes, quit and restart your app."
  end

  def publish_pending
    "Your app is pending publishing in the App Stores. We'll send you an email once your app is live in each store."
  end
end