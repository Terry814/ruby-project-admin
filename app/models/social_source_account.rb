# == Schema Information
#
# Table name: social_source_accounts
#
#  id               :integer          not null, primary key
#  service          :integer
#  username         :string(255)
#  list_name        :string(255)
#  social_stream_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  hashtag          :string(255)
#  service_user_id  :string(255)
#
# Indexes
#
#  index_social_source_accounts_on_service           (service)
#  index_social_source_accounts_on_social_stream_id  (social_stream_id)
#

class SocialSourceAccount < ActiveRecord::Base
  belongs_to :social_stream, touch: true
  enum service: %w(facebook twitter instagram youtube)

  has_many :autopost_social_source_accounts, dependent: :destroy

  validates_presence_of :service
  validates_presence_of :username, if: proc { hashtag.blank? }
  validates_presence_of :hashtag, if: proc { (twitter? || instagram?) && username.blank? }
  validates_inclusion_of :service, in: services
  validates_presence_of :service_user_id, if: proc { username.present? }
  validates_existence_of :social_stream, both: false
  validates_uniqueness_of :service_user_id, scope: [:social_stream_id, :service], allow_nil: true,
                                            unless: proc { social_stream.new_record? }
  validates_uniqueness_of :hashtag, scope: [:social_stream_id, :service], allow_nil: true,
                                          unless: proc { social_stream.new_record? }

  before_validation :check_if_user_exists
  after_validation :set_service_errors_to_username # to present to user

  private

  def check_if_user_exists
    if hashtag.present? # don't care if source type is hashtag
      hashtag.delete! '#'
      return true
    end
    return true if username.blank? # go fill it
#    suppress(Exception) do
      case service
      when 'facebook'
        fetch_facebook_user_id
      when 'twitter'
        fetch_twitter_id
      when 'instagram'
        fetch_instagram_user_id
      when 'youtube'
        fetch_youtube_channel_id
      end
#    end
    true
  end

  def set_service_errors_to_username
    service_errors = errors[:service_user_id]
    errors.delete :service_user_id
    service_errors.each { |e| errors.add(:username, e) }
  end

  def fetch_facebook_user_id
    user_res = HTTParty.get("http://graph.facebook.com/#{username}")
    logger.info("Facebook res: #{user_res.inspect}")
    self.service_user_id = if user_res.ok?
      JSON.parse(user_res.body)['id']
    else
      access_token = Identity.where(
        provider: Identity.providers[:facebook],
        expires_at: Date.tomorrow..99.years.from_now
        ).sample.access_token

      koala = Koala::Facebook::API.new(access_token)
      obj = koala.get_object('', id: username)['id']
      logger.info("obj from Koala: #{obj.inspect}")
      obj
    end
  end

  def fetch_twitter_id
    username.delete! '@'
    self.service_user_id = if list_name.blank?
      twitter_client.user(username, skip_status: true).id
    else
      twitter_client.list(username, list_name).id
    end
  end

  def fetch_instagram_user_id
    username.delete! '@'
    user_search_url = "https://api.instagram.com/v1/users/search?q=#{username}&client_id=#{ENV['INSTAGRAM_CLIENT_ID']}&count=20"
    user_res = HTTParty.get(user_search_url)
    if user_res.ok?
      JSON.parse(user_res.body)['data'].each do |user|
        self.service_user_id = user['id'] and break if user['username'] == username
      end
    end
  end

  def fetch_youtube_channel_id
    user_search_url = "https://www.googleapis.com/youtube/v3/channels?part=snippet&key=#{ENV['GOOGLE_API_KEY']}&forUsername=#{username}"
    user_res = HTTParty.get(user_search_url, :verify => false)
    logger.info("Youtube res: #{user_res.inspect}")
    self.service_user_id = JSON.parse(user_res.body)['items'].first['id'] if user_res.ok?
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end
end
