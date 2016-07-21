class AddOnesignalAppKeyToApplicationInfo < ActiveRecord::Migration
  def change
    add_column :application_infos, :onesignal_app_key, :string
  end
end
