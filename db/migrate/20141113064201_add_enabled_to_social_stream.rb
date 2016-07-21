class AddEnabledToSocialStream < ActiveRecord::Migration
  def change
    add_column :social_streams, :enabled, :boolean, default: false
  end
end
