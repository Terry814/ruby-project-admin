class ChangeTypeColumnNameOnMenuItem < ActiveRecord::Migration
  def change
    rename_column :menu_items, :type, :menu_type
  end
end
