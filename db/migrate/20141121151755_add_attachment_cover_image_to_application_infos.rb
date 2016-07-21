class AddAttachmentCoverImageToApplicationInfos < ActiveRecord::Migration
  def self.up
    change_table :application_infos do |t|
      t.attachment :cover_image
    end
  end

  def self.down
    remove_attachment :application_infos, :cover_image
  end
end
