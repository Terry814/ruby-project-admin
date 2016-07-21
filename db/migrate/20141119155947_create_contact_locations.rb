class CreateContactLocations < ActiveRecord::Migration
  def change
    create_table :contact_locations do |t|
      t.string :name
      t.string :street_line_one
      t.string :street_line_two
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :email
      t.string :phone_number

      t.timestamps
    end
  end
end
