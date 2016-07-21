class RenameUserIdColumnInSocialStoreAccount < ActiveRecord::Migration
  def change
    rename_column :social_source_accounts, :user_id, :service_user_id
  end
end
