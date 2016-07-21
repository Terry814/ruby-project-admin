class CreateGeoMessages < ActiveRecord::Migration
  def change
    create_table :geo_messages do |t|
      t.string :message
      t.references :contact_location, index: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
