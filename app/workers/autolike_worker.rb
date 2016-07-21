class AutolikeWorker
  include Sidekiq::Worker
  sidekiq_options queue: :autolike

  def perform autolike_id
    @autolike = Autolike.find(autolike_id)

    if @autolike.hashtags.empty?
      schedule_next
      return
    end

    tw_id = @autolike.application_info.user.identities
      .where(provider: Identity.providers[:twitter]).first

    if tw_id.nil?
      schedule_next
      return
    end

    @client = tw_client_for tw_id

    posts = @autolike.hashtags
      .flat_map { |h| most_liked_posts(h) }
      .max_by(3, &:favorite_count)
      .each { |post| @client.favorite post }

    latest = posts.max_by(&:created_at)

    if latest
      @autolike.latest_id = latest.id.to_s
      @autolike.save
    end

    schedule_next
  end

  private

  def most_liked_posts hashtag
    params = {result_type: :mixed, count: 100}
    params[:since_id] = @autolike.latest_id if @autolike.latest_id

    @client.search("##{hashtag}", params)
      .take(100)
      .select { |post| post.favorite_count >= 3 && post.user.followers_count >= 25 }
      .select { |post| !post.favorited? }
      .max_by(20, &:favorite_count)
  end

  def schedule_next
    return unless @autolike.enabled
    AutolikeWorker.perform_in(Autolike::INTERVAL, @autolike.id)
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
