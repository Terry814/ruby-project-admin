# == Schema Information
#
# Table name: app_stores_infos
#
#  id                      :integer          not null, primary key
#  ios_app_name            :string(255)
#  ios_icon_label          :string(255)
#  ios_first_category      :string(255)
#  ios_second_category     :string(255)
#  ios_description         :text
#  android_app_name        :string(255)
#  android_icon_label      :string(255)
#  android_first_category  :string(255)
#  android_second_category :string(255)
#  android_description     :text
#  application_info_id     :integer
#  created_at              :datetime
#  updated_at              :datetime
#  app_icon_file_name      :string(255)
#  app_icon_content_type   :string(255)
#  app_icon_file_size      :integer
#  app_icon_updated_at     :datetime
#  itunes_link             :string(255)
#  play_market_link        :string(255)
#
# Indexes
#
#  index_app_stores_infos_on_application_info_id  (application_info_id)
#

class AppStoresInfo < ActiveRecord::Base
  belongs_to :application_info
  has_many :app_screenshots, dependent: :destroy

  APPSTORE_CATEGORIES = Rails.configuration.stores_categories.appstore
  PLAY_MARKET_CATEGORIES = Rails.configuration.stores_categories.play_market

  has_attached_file :app_icon, styles: {itunes: '1024x1024#', thumb: '300x300#'},
            default_url: "https://appease.s3.amazonaws.com/images/default_appicon.png"

  validates_presence_of :ios_app_name, :ios_icon_label, :ios_first_category, :ios_description, if: Proc.new { @updating_ios }
  validates_presence_of :android_app_name, :android_icon_label, :android_first_category, :android_description, if: Proc.new { @updating_android }

  validates_inclusion_of :ios_first_category, in: APPSTORE_CATEGORIES.keys.map(&:to_s), allow_blank: true
  validates_inclusion_of :ios_second_category, in: APPSTORE_CATEGORIES.keys.map(&:to_s), allow_blank: true
  validates_inclusion_of :android_first_category, in: PLAY_MARKET_CATEGORIES.keys.map(&:to_s), allow_blank: true
  validates_inclusion_of :android_second_category, in: PLAY_MARKET_CATEGORIES.keys.map(&:to_s), allow_blank: true

  validates_attachment :app_icon, content_type: 
          { content_type: ["image/jpeg", "image/png"] }
  validates_attachment_file_name :app_icon, matches: [/png\Z/, /jpe?g\Z/]

  attr_accessor :updating_ios, :updating_android

  def valid_for_itunes?
    @updating_ios = true
    @updating_android = false
    val = valid?
    @updating_ios = false
    val
  end

  def valid_for_play_market?
    @updating_android = true
    @updating_ios = false
    val = valid?
    @updating_android = false
    val
  end
end
