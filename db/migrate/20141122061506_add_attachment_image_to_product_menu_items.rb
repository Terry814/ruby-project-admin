class AddAttachmentImageToProductMenuItems < ActiveRecord::Migration
  def self.up
    change_table :product_menu_items do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :product_menu_items, :image
  end
end
