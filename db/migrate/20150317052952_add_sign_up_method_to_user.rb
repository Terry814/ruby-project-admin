class AddSignUpMethodToUser < ActiveRecord::Migration
  def change
    add_column :users, :sign_up_method, :integer, default: 0
  end
end
