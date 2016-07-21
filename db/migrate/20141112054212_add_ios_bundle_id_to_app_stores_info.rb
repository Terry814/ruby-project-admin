class AddIosBundleIdToAppStoresInfo < ActiveRecord::Migration
  def change
    add_column :app_stores_infos, :ios_bundle_id, :string
  end
end
