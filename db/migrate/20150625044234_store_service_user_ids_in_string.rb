class StoreServiceUserIdsInString < ActiveRecord::Migration
  def up
    add_column :social_source_accounts, :service_user_id_str, :string
    SocialSourceAccount.find_each { |acc| acc.update_column(:service_user_id_str, acc.service_user_id) }
    remove_column :social_source_accounts, :service_user_id
    rename_column :social_source_accounts, :service_user_id_str, :service_user_id
  end

  def down
  end
end
