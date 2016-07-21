app_id_key = Rails.env.production? ? "INTERCOM_APP_ID" : "INTERCOM_DEV_ID"
app_key_key = Rails.env.production? ? "INTERCOM_API_KEY" : "INTERCOM_DEV_KEY"

Intercom.app_id = ENV[app_id_key]
Intercom.app_api_key = ENV[app_key_key]

IntercomRails.config do |config|
  # == Intercom app_id
  #
  config.app_id = ENV[app_id_key]

  # == Intercom secret key
  # This is required to enable secure mode, you can find it on your Intercom
  # "security" configuration page.
  #
  # config.api_secret = "..."

  # == Intercom API Key
  # This is required for some Intercom rake tasks like importing your users;
  # you can generate one at https://app.intercom.io/apps/api_keys.
  #
  # config.api_key = "..."

  # == Enabled Environments
  # Which environments is auto inclusion of the Javascript enabled for
  #
  config.enabled_environments = ["development", "production", "staging"]

  # == Exclude users
  # A Proc that given a user returns true if the user should be excluded
  # from imports and Javascript inclusion, false otherwise.
  #
  config.user.exclude_if = Proc.new { |user| user.admin? }
  config.user.current = Proc.new { original_user }

  # == User Custom Data
  # A hash of additional data you wish to send about your users.
  # You can provide either a method name which will be sent to the current
  # user object, or a Proc which will be passed the current user.
  #
  config.user.custom_data = {
    name: :full_name,
    package: :plan_name,
    unsubscribed_from_emails: proc {|user| !user.subscribed_to_emails},
    last_published_at: :last_published_at,
    sign_up_method: :sign_up_method
  }

  # == Inbox Style
  # This enables the Intercom inbox which allows your users to read their
  # past conversations with your app, as well as start new ones. It is
  # disabled by default.
  #   * :default shows a small tab with a question mark icon on it
  #   * :custom attaches the inbox open event to an anchor with an
  #             id of #Intercom.
  #
  config.inbox.style = :default
  # config.inbox.style = :custom
end
