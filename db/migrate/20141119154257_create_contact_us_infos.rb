class CreateContactUsInfos < ActiveRecord::Migration
  def change
    create_table :contact_us_infos do |t|
      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end
