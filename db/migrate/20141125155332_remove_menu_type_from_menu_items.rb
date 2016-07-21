class RemoveMenuTypeFromMenuItems < ActiveRecord::Migration
  def change
    remove_column :menu_items, :menu_type
  end
end
