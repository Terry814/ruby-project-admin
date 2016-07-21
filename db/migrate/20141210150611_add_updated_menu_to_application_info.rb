class AddUpdatedMenuToApplicationInfo < ActiveRecord::Migration
  def change
    add_column :application_infos, :updated_menu, :boolean, default: false
  end
end
