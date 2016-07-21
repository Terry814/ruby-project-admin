# == Schema Information
#
# Table name: app_screenshots
#
#  id                 :integer          not null, primary key
#  app_stores_info_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#
# Indexes
#
#  index_app_screenshots_on_app_stores_info_id  (app_stores_info_id)
#

class AppScreenshot < ActiveRecord::Base
  belongs_to :app_stores_info

  has_attached_file :image, styles: {thumb: '300x450>'}
  validates_presence_of :image
  validates_attachment :image, content_type: 
          { content_type: ["image/jpeg", "image/png"] }
  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/]
end
