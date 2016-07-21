class CreateAppStoresInfos < ActiveRecord::Migration
  def change
    create_table :app_stores_infos do |t|
      t.string :ios_app_name
      t.string :ios_icon_label
      t.string :ios_first_category
      t.string :ios_second_category
      t.string :ios_description

      t.string :android_app_name
      t.string :android_icon_label
      t.string :android_first_category
      t.string :android_second_category
      t.string :android_description

      t.references :application_info, index: true

      t.timestamps
    end
  end
end
