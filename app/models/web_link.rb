# == Schema Information
#
# Table name: web_links
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class WebLink < ActiveRecord::Base
  include MenuItemInfoObject

  validates_presence_of :url
  validates :url, url: true, allow_blank: true

  before_validation :add_url_protocol

  def menu_type
    'web'
  end

  def self.is_enabled_by_default?
    true
  end

  private

  def add_url_protocol
    unless URI(url).scheme.present?
      self.url = "http://#{self.url}"
    end
  end
end
