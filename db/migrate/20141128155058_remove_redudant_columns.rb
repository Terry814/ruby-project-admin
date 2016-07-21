class RemoveRedudantColumns < ActiveRecord::Migration
  def change
    remove_column :menu_items, :icon
    remove_column :menu_items, :home_menu
    remove_column :users, :application_info_id
  end
end
