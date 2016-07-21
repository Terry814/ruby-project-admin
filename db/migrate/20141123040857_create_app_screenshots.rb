class CreateAppScreenshots < ActiveRecord::Migration
  def change
    create_table :app_screenshots do |t|
      t.references :app_stores_info, index: true

      t.timestamps
    end
  end
end
