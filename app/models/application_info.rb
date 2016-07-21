# == Schema Information
#
# Table name: application_infos
#
#  id                       :integer          not null, primary key
#  created_at               :datetime
#  updated_at               :datetime
#  user_id                  :integer
#  cover_image_file_name    :string(255)
#  cover_image_content_type :string(255)
#  cover_image_file_size    :integer
#  cover_image_updated_at   :datetime
#  app_id_suffix            :string(255)
#  updated_menu             :boolean          default(FALSE)
#  json_fetched_by_preview  :boolean          default(FALSE)
#  last_published_at        :datetime
#  json_fetched_by_instant  :boolean          default(FALSE)
#  cover_image_style        :integer          default(0)
#  ad_frequency             :integer          default(0)
#  onesignal_app_id         :string(255)
#  onesignal_app_key        :string(255)
#
# Indexes
#
#  index_application_infos_on_user_id  (user_id)
#

class ApplicationInfo < ActiveRecord::Base
  belongs_to :user
  has_one :app_colors, dependent: :destroy
  has_one :app_stores_info, dependent: :destroy
  has_one :autopost, dependent: :destroy
  has_one :autolike, dependent: :destroy

  has_many :menu_items, -> { order("position ASC") }, dependent: :destroy
  has_many :app_installs, class_name: AppInstalls, dependent: :destroy
  has_many :geo_messages, dependent: :destroy
  attr_accessor :app_home

  enum cover_image_style: %w( plain square circle )

  has_attached_file :cover_image, styles: { retina: "500x250#" },
                          keep_old_files: true,
             default_url: "https://appease.s3.amazonaws.com/images/default_coverimage.png"
  validates_attachment :cover_image, content_type:
          { content_type: ["image/jpeg", "image/png"] }
  validates_attachment_file_name :cover_image, matches: [/png\Z/, /jpe?g\Z/]

  before_create :build_app_colors, :build_app_stores_info

  after_touch :notify_clients
  after_save :notify_clients
  after_post_process :notify_clients

  def adjust_menu_items_for_package
    ability = Ability.new(user)
    has_changes = false
    ApplicationInfo.no_touching do
      menu_items.find_each do |item|
        info_object_class = item.info_object_type.constantize
        if item.enabled
          if ability.cannot? :manage, info_object_class
            item.update(enabled: false)
            has_changes = true
          end
        elsif ability.can? :manage, info_object_class &&
         info_object_class.respond_to?(:is_enabled_by_default?) &&
         info_object_class.is_enabled_by_default?
          item.update(enabled: true)
          has_changes = true
        end
      end
    end
    touch if has_changes
  end

  def social_source_accounts
    SocialStream.of_app(self).flat_map(&:social_source_accounts)
  end

  def published?
    last_published_at.present?
  end

  def published_to_stores?
    app_stores_info.itunes_link.present? && app_stores_info.play_market_link.present?
  end

  private

  def notify_clients
    logger.debug "About to send notify clients"
    NotifyClientsJob.new.async.perform(onesignal_app_id, onesignal_app_key, app_id_suffix)
  end
end
