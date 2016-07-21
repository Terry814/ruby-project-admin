class AddPositionToProductMenuItems < ActiveRecord::Migration
  def change
    add_column :product_menu_items, :position, :integer, default: 0
  end
end
