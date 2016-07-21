class AddJsonFetchedToApplicationInfo < ActiveRecord::Migration
  def change
    add_column :application_infos, :json_fetched, :boolean, default: false
  end
end
