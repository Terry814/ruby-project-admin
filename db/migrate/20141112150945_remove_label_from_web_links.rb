class RemoveLabelFromWebLinks < ActiveRecord::Migration
  def change
    remove_column :web_links, :label
  end
end
