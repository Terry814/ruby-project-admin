class AddJsonFetchedByInstantToApplicationInfo < ActiveRecord::Migration
  def change
    add_column :application_infos, :json_fetched_by_instant, :boolean, default: false
  end
end
