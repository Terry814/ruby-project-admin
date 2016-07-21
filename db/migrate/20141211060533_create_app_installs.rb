class CreateAppInstalls < ActiveRecord::Migration
  def change
    create_table :app_installs do |t|
      t.integer :total
      t.date :as_of_day
      t.references :application_info, index: true

      t.timestamps
    end
  end
end
