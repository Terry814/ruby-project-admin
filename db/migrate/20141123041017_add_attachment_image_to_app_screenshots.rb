class AddAttachmentImageToAppScreenshots < ActiveRecord::Migration
  def self.up
    change_table :app_screenshots do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :app_screenshots, :image
  end
end
