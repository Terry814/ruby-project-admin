class MigrateAllUsersToMaxPackage < ActiveRecord::Migration
  def up
    User.all.each { |u| u.update_columns(current_package: User.current_packages['max']) }
  end

  def down
    raise 'Non reversible'
  end
end
