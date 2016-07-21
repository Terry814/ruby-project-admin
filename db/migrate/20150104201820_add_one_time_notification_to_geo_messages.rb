class AddOneTimeNotificationToGeoMessages < ActiveRecord::Migration
  def change
    add_column :geo_messages, :one_time_notification, :boolean, default: false
  end
end
