class AddPlainToWebLinks < ActiveRecord::Migration
  def change
    add_column :web_links, :plain, :boolean, default: false
  end
end
