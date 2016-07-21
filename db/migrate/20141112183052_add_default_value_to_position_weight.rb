class AddDefaultValueToPositionWeight < ActiveRecord::Migration
  def change
    change_column_default :menu_items, :position_weight, 0
  end
end
