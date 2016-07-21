class AddHashtagToSocialSourceAccounts < ActiveRecord::Migration
  def change
    add_column :social_source_accounts, :hashtag, :string
  end
end
