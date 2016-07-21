class AddSinceIdToAutolikes < ActiveRecord::Migration
  def change
    add_column :autolikes, :latest_id, :string
  end
end
