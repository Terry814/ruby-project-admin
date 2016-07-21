class AddLastPublishedAtToApplicationInfo < ActiveRecord::Migration
  def change
    add_column :application_infos, :last_published_at, :datetime
  end
end
