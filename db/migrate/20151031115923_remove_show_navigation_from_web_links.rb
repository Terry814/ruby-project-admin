class RemoveShowNavigationFromWebLinks < ActiveRecord::Migration
  def change
    remove_column :web_links, :show_navigation
  end
end
