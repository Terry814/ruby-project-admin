class UseLatLngOnGeoMessages < ActiveRecord::Migration
  def self.up
    drop_table :geo_messages

    create_table :geo_messages do |t|
      t.string :message
      t.references :application_info, index: true
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
