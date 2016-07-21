class AddIsHomeMenuToMenuItem < ActiveRecord::Migration
  def change
    add_column :menu_items, :home_menu, :boolean, default: false
  end
end
