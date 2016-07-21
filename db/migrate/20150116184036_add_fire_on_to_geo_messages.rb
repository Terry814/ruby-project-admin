class AddFireOnToGeoMessages < ActiveRecord::Migration
  def change
    add_column :geo_messages, :fire_on, :integer, default: 0
  end
end
