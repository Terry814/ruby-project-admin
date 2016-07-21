class RemoveStreetLineTwoFromContactLocations < ActiveRecord::Migration
  def change
    remove_column(:contact_locations, :street_line_two)
  end
end
