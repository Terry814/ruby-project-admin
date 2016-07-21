class RenameJsonFetchedColumnInApplicationInfos < ActiveRecord::Migration
  def change
    rename_column :application_infos, :json_fetched, :json_fetched_by_preview
  end
end
