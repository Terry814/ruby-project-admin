class MoveAppIdSuffixToApplicationInfo < ActiveRecord::Migration
  def up
    add_column :application_infos, :app_id_suffix, :string
    AppStoresInfo.all.each { |info| info.application_info.update_columns(app_id_suffix: info.ios_bundle_id_suffix) }
    remove_column :app_stores_infos, :ios_bundle_id_suffix
  end

  def down
    add_column :app_stores_infos, :ios_bundle_id_suffix, :string
    AppStoresInfo.all.each { |info| info.update_columns(ios_bundle_id_suffix: info.application_info.app_id_suffix) }
    remove_column :application_infos, :app_id_suffix
  end
end
