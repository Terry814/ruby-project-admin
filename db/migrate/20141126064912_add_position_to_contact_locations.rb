class AddPositionToContactLocations < ActiveRecord::Migration
  def change
    add_column :contact_locations, :position, :integer, default: 0
  end
end
