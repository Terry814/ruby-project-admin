class CreateApplicationInfos < ActiveRecord::Migration
  def change
    create_table :application_infos do |t|

      t.timestamps
    end
  end
end
