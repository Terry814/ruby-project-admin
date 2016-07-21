class CreateProductMenus < ActiveRecord::Migration
  def change
    create_table :product_menus do |t|
      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end
