class AutopostRepostWorker
  include Sidekiq::Worker
  sidekiq_options queue: :autopost

  FB_FIELDS = "name,message,picture,type,story,description,link,object_id,created_time,likes.limit(1).fields(id).summary(true)"
  T_CO_LENTH = 24

  class Post
    attr_reader :service, :id, :like_count, :message, :link, :picture_link

    def initialize(service, id, like_count, message, link, picture_link = nil)
      @service, @id, @like_count, @message, @link, @picture_link = service, id, like_count, message, link, picture_link
    end
  end

  def perform autopost_id
    @autopost = Autopost.find(autopost_id)
    @since_date = @autopost.interval.seconds.ago

    hashtag = @autopost.hashtag.present? ? '#' + @autopost.hashtag : nil
    @message = [hashtag, @autopost.url].select(&:present?).compact.join(", ")

    identities = @autopost.identities.to_a
    if identities.empty?
      schedule_next
      return
    end

    sources = @autopost.social_source_accounts.to_a

    if sources.any?(&:facebook?)
      access_token = Identity.where(
        provider: Identity.providers[:facebook],
        expires_at: Date.tomorrow..99.years.from_now
        ).sample.access_token
      @graph = Koala::Facebook::API.new(access_token)
    end

    if sources.any?(&:twitter?)
      identity = Identity.where(
        provider: Identity.providers[:twitter],
        ).sample
      @twitter_client = tw_client_for identity
    end

    if sources.any?(&:instagram?)
      @instagram_token = Identity.where(
        provider: Identity.providers[:instagram],
        ).sample.access_token
    end

    most_liked_posts = sources.map { |s| most_liked_post(s) }

    to_share = most_liked_posts.compact.max_by(&:like_count)
    share_post(to_share, identities) if to_share

    schedule_next
  end

  private

  def share_post post, connections
    suppress(Exception) do
      connections.each do |connection|
        case connection.provider
        when 'facebook'
          fb_post post, connection
        when 'twitter'
          tw_tweet post, connection
        end
      end
    end
  end

  def most_liked_post social_source
    suppress(Exception) do
      case social_source.service
      when 'facebook'
        return fb_most_liked_post(social_source.service_user_id)
      when 'twitter'
        return tw_most_liked_post social_source
      when 'instagram'
        return ig_most_liked_post social_source
      end
    end
    return nil
  end

  def fb_most_liked_post user_id
    most_liked = @graph.get_connection(user_id, 'feed', {
      fields: FB_FIELDS, limit: 100, since: @since_date
      }).max_by { |post| fb_like_count(post) }
    picture_url = if most_liked['picture']
      url = URI.parse(most_liked['picture'])
      Rack::Utils.parse_nested_query(url.query)['url']
    end
    message = most_liked['message'] || most_liked['name'] || most_liked['description']
    id_parts = most_liked['id'].split('_')
    post_link = "https://www.facebook.com/#{id_parts.first}/posts/#{id_parts.last}"
    Post.new(:fb, most_liked['id'], fb_like_count(most_liked), message, post_link, picture_url)
  end

  def tw_most_liked_post social_source
    return nil if social_source.list_name.present?
    hashtag = social_source.hashtag
    q = hashtag.present? ? '#' + hashtag : 'from:' + social_source.username

    max_post = @twitter_client.search(q, result_type: :recent, count: 100)
      .take(100)
      .select { |post| post.created_at >= @since_date }
      .max_by(&:favorite_count)
    Post.new(:tw, max_post.id, max_post.favorite_count, max_post.text, max_post.url.to_s)
  end

  def ig_most_liked_post social_source
    path = if social_source.hashtag.present?
      "tags/#{social_source.hashtag}/media/recent"
    else
      "users/#{social_source.service_user_id}/media/recent"
    end

    res = HTTParty.get("https://api.instagram.com/v1/#{path}",
      query: { access_token: @instagram_token, count: 50,
        min_timestamp: @since_date.to_i })

    max_post = res['data']
      .select { |post| post['created_time'].to_i >= @since_date.to_i }
      .max_by { |post| ig_like_count post }
    Post.new(:ig, max_post['id'], ig_like_count(max_post),
      max_post['caption']['text'], max_post['link'],
      max_post['images']['standard_resolution']['url'])
  end

  def fb_like_count post_hash
    post_hash['likes']['summary']['total_count']
  end

  def ig_like_count post_hash
    post_hash['likes']['count']
  end

  def fb_post post, to_acc
    return if to_acc.expires_at.past?
    @user_fb ||= Koala::Facebook::API.new(to_acc.access_token)
    @user_fb.put_wall_post @message, link: post.link
  end

  def tw_tweet post, to_acc
    @user_tw ||= tw_client_for to_acc

    if post.service == :tw
      @user_tw.update("#{@message} #{post.link}")
    else
      pic = open(post.picture_link) if post.picture_link.present?

      links = [@autopost.url, post.link].select(&:present?).compact
      items_count = pic ? links.count + 1 : links.count
      links_length = items_count.zero? ? 0 : items_count * T_CO_LENTH + items_count
      links_str = links.any? ? ' ' + links.join(' ') : ''

      hashtag_str = @autopost.hashtag.present? ? "##{@autopost.hashtag} " : ''

      message = post.message.truncate(140 - links_length - hashtag_str.length, separator: /\s/)
      tweet = hashtag_str + message + links_str
      if pic
        @user_tw.update_with_media tweet, pic
      else
        @user_tw.update tweet
      end
    end
  end

  def schedule_next
    return unless @autopost.enabled
    AutopostRepostWorker.perform_in(@autopost.interval.seconds, @autopost.id)
  end

  def tw_client_for identity
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = identity.access_token
      config.access_token_secret = identity.access_token_secret
    end
  end
end
