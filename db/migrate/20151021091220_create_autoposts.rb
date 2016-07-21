class CreateAutoposts < ActiveRecord::Migration
  def change
    create_table :autoposts do |t|
      t.boolean :enabled
      t.integer :interval
      t.boolean :randomized
      t.string :hashtag
      t.string :url

      t.references :application_info, index: true
      t.timestamps
    end
  end
end
