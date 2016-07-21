class AddLastChangedPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_changed_password_at, :datetime
  end
end
