class ChangeServiceUserIdInBigint < ActiveRecord::Migration
  def up
    add_column :social_source_accounts, :service_user, :bigint
    SocialSourceAccount.all.each { |a| a.update_columns(service_user: a.service_user_id) }
    remove_column :social_source_accounts, :service_user_id
    rename_column :social_source_accounts, :service_user, :service_user_id
  end

  def down
    add_column :social_source_accounts, :service_user, :int
    SocialSourceAccount.all.each { |a| a.update_columns(service_user: a.service_user_id) }
    remove_column :social_source_accounts, :service_user_id
    rename_column :social_source_accounts, :service_user, :service_user_id
  end
end
