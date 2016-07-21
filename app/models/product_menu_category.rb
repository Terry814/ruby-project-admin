# == Schema Information
#
# Table name: product_menu_categories
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  position        :integer          default(0)
#  product_menu_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_product_menu_categories_on_product_menu_id  (product_menu_id)
#

class ProductMenuCategory < ActiveRecord::Base
  belongs_to :product_menu, inverse_of: :categories, touch: true
  acts_as_list scope: :product_menu
  has_many :product_menu_items, -> { order("position ASC")}, dependent: :destroy

  validates_presence_of :name
  validates_existence_of :product_menu, both: false
end
