# == Schema Information
#
# Table name: product_menu_items
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  description              :string(255)
#  price                    :float
#  product_menu_category_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#  image_file_name          :string(255)
#  image_content_type       :string(255)
#  image_file_size          :integer
#  image_updated_at         :datetime
#  position                 :integer          default(0)
#
# Indexes
#
#  index_product_menu_items_on_product_menu_category_id  (product_menu_category_id)
#

class ProductMenuItem < ActiveRecord::Base
  belongs_to :product_menu_category, touch: true
  acts_as_list scope: :product_menu_category
  
  has_attached_file :image, preserve_files: true
  
  validates_presence_of :name, :price, :description, :product_menu_category_id
  validates_existence_of :product_menu_category, both: false
  validates_attachment :image, content_type: 
          { content_type: ["image/jpeg", "image/png"] }
  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/]
end
