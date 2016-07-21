class RenamePlainInWebLinks < ActiveRecord::Migration
  def up
    WebLink.all.each { |w| w.update_columns(plain: !w.plain) }
    rename_column :web_links, :plain, :show_navigation
  end
  def down
    WebLink.all.each { |w| w.update_columns(show_navigation: !w.show_navigation) }
    rename_column :web_links, :show_navigation, :plain
  end
end
