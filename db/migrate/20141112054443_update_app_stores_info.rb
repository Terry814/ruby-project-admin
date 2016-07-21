class UpdateAppStoresInfo < ActiveRecord::Migration
  def up
    change_column :app_stores_infos, :ios_description, :text, limit: nil
    change_column :app_stores_infos, :android_description, :text, limit: nil
    rename_column :app_stores_infos, :ios_bundle_id, :ios_bundle_id_suffix
  end

  def down
    change_column :app_stores_infos, :ios_description, :string
    change_column :app_stores_infos, :android_description, :string
    rename_column :app_stores_infos, :ios_bundle_id_suffix, :ios_bundle_id
  end
end
