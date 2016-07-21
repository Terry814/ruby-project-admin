class AddAttachmentAppIconToAppStoresInfos < ActiveRecord::Migration
  def self.up
    change_table :app_stores_infos do |t|
      t.attachment :app_icon
    end
  end

  def self.down
    remove_attachment :app_stores_infos, :app_icon
  end
end
