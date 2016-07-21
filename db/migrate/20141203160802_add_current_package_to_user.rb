class AddCurrentPackageToUser < ActiveRecord::Migration
  def change
    add_column :users, :current_package, :integer, default: 0
  end
end
