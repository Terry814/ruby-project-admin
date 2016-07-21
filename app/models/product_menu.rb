# == Schema Information
#
# Table name: product_menus
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class ProductMenu < ActiveRecord::Base
  include MenuItemInfoObject

  has_many :categories, -> { order("position ASC") }, dependent: :destroy, class_name: "ProductMenuCategory"
  has_many :menu_items, through: :categories, source: :product_menu_items

  def menu_type
    'product_menu'
  end
end
