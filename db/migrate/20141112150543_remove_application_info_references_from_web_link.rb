class RemoveApplicationInfoReferencesFromWebLink < ActiveRecord::Migration
  def change
    change_table :web_links do |t|
      t.remove_references :application_info, index: true
    end
  end
end
