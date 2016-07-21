module AppMarketingHelper
  def autopost_interval_options
    Autopost::INTERVAL_OPTIONS.map do |seconds|
      label = if seconds <= 1.hour
        "#{seconds / 60} minutes"
      else
        "#{seconds / 3600} hours"
      end
      [label, seconds]
    end
  end

  def social_source_accounts_hint
    "These are your social accounts from #{link_to("Social Stream", app_settings_social_streams_path)}.".html_safe
  end

  def social_source_account_label acc
    icon = content_tag(:i, '', class: "fa fa-#{acc.service}")
    username = acc.hashtag.present? ? "##{acc.hashtag}" : acc.username
    "#{icon} #{username}".html_safe
  end

  def twitter_connection_hint
    "This is your social account from #{link_to("Twitter", app_settings_path(:twitter))}.".html_safe
  end

  def connection_label conn
    icon = content_tag(:i, '', class: "fa fa-#{conn.provider}")
    "#{icon} #{conn.provider.capitalize}".html_safe
  end

  def autopost_social_sources
    current_application.social_source_accounts
      .select { |s| !s.youtube? && s.list_name.blank? }
  end
end
