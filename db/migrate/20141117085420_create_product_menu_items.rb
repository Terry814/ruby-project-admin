class CreateProductMenuItems < ActiveRecord::Migration
  def change
    create_table :product_menu_items do |t|
      t.string :name
      t.string :description
      t.float :price
      t.references :product_menu_category, index: true

      t.timestamps
    end
  end
end
