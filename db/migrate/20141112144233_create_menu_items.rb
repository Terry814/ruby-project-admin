class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.integer :type
      t.string :display_name
      t.integer :position_weight
      t.string :icon
      t.boolean :app_home, default: false

      t.references :application_info, index: true
      t.references :info_object, polymorphic: true, index: true

      t.timestamps
    end
    add_index :menu_items, :type
  end
end
