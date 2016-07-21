class CreateAdPlacementIds < ActiveRecord::Migration
  def change
    create_table :ad_placement_ids do |t|
      t.string :placement_id
      t.integer :platform

      t.timestamps
    end
  end
end
