class SocialLinksImportJob
  include SuckerPunch::Job
  include SocialLinkHelper

  def perform(app, social_links)
    @current_application = app

    ActiveRecord::Base.connection_pool.with_connection do
      ApplicationInfo.no_touching do
        populate_social_accounts(social_links)
      end
    end
  end

  private

  def populate_social_accounts links
    return if links.empty?

    social_stream = SocialStream.first_of_app_or_initialize @current_application
    if social_stream.new_record?
      social_stream.update(menu_item_attributes: {enabled: true, display_name: "Social Stream", app_home: true})
    end

    links.each do |link|
      case URI(link).host
      when /twitter/
        handle_twitter_link(link, social_stream)
      when /facebook/
        handle_fb_link(link, social_stream)
      when /instagram/
        handle_instagram_link(link, social_stream)
      end
    end
  end

  def handle_twitter_link link, social_stream
    suppress(Exception) do
      username = get_username_or_id link
      user_id = twitter_client.user(username, skip_status: true).id
      social_stream.social_source_accounts.create(
        service: 'twitter', username: username, service_user_id: user_id
      )
    end
  end

  def handle_fb_link link, social_stream
    suppress(Exception) do
      id = get_username_or_id link
      # try graph api
      user_res = HTTParty.get("http://graph.facebook.com/#{id}")
      user = if user_res.ok?
        JSON.parse(user_res.body)
      else
        @access_token ||= Identity.where(
          provider: Identity.providers[:facebook],
          expires_at: Date.tomorrow..99.years.from_now
          ).sample.access_token

        Koala::Facebook::API.new(@access_token).get_object('', id: id)
      end
      social_stream.social_source_accounts.create(
        service: 'facebook', username: user['username'], service_user_id: user['id']
      )
    end
  end

  def handle_instagram_link link, social_stream
    suppress(Exception) do
      username = get_username_or_id link
      user_search_url = "https://api.instagram.com/v1/users/search?q=#{username}&client_id=#{ENV['INSTAGRAM_CLIENT_ID']}&count=1"
      user_id = JSON.parse(HTTParty.get(user_search_url).body)['data'].first['id']
      social_stream.social_source_accounts.create(
        service: 'instagram', username: username, service_user_id: user_id
      )
    end
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      if ENV['TWITTER_BEARER_TOKEN'].present?
        config.bearer_token    = ENV['TWITTER_BEARER_TOKEN']
      end
    end
  end
end
