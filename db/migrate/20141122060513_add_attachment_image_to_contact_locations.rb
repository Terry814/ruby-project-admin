class AddAttachmentImageToContactLocations < ActiveRecord::Migration
  def self.up
    change_table :contact_locations do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :contact_locations, :image
  end
end
