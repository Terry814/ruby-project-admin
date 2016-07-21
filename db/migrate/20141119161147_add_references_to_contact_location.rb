class AddReferencesToContactLocation < ActiveRecord::Migration
  def change
    add_reference :contact_locations, :contact_us_info, index: true
  end
end
