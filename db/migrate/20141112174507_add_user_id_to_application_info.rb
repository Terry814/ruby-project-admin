class AddUserIdToApplicationInfo < ActiveRecord::Migration
  def change
    change_table :application_infos do |t|
      t.references :user, index: true 
    end
  end
end
