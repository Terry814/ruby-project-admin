class AddStoresLinksToAppStoresInfo < ActiveRecord::Migration
  def change
    add_column :app_stores_infos, :itunes_link, :string
    add_column :app_stores_infos, :play_market_link, :string
  end
end
