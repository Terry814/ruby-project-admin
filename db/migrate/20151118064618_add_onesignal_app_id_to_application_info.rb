class AddOnesignalAppIdToApplicationInfo < ActiveRecord::Migration
  def change
    add_column :application_infos, :onesignal_app_id, :string
  end
end
