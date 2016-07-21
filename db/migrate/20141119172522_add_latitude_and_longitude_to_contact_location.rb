class AddLatitudeAndLongitudeToContactLocation < ActiveRecord::Migration
  def change
    add_column :contact_locations, :latitude, :float
    add_column :contact_locations, :longitude, :float
  end
end
