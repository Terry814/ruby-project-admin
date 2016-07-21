# == Schema Information
#
# Table name: open_tables
#
#  id         :integer          not null, primary key
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class OpenTable < ActiveRecord::Base
  include MenuItemInfoObject
  
  validates_presence_of :url
  validates :url, url: true, allow_blank: true

  before_validation :add_url_protocol

  def menu_type
    'opentable'
  end
  
  private

  def add_url_protocol
    unless URI(url).scheme.present?
      self.url = "http://#{self.url}"
    end
  end
end
