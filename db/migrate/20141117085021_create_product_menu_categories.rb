class CreateProductMenuCategories < ActiveRecord::Migration
  def change
    create_table :product_menu_categories do |t|
      t.string :name
      t.integer :position, default: 0
      t.references :product_menu, index: true

      t.timestamps
    end
  end
end
