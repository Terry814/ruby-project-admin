class CreateAutolikes < ActiveRecord::Migration
  def change
    create_table :autolikes do |t|
      t.boolean :enabled
      t.text :hashtags

      t.references :application_info, index: true
      t.timestamps
    end
  end
end
