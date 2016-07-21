class CreateAutopostSocialSourceAccounts < ActiveRecord::Migration
  def change
    create_table :autopost_social_source_accounts do |t|
      t.references :autopost, index: true
      t.references :social_source_account, index: { name: 'index_autopost_social_source_accounts_id' }

      t.timestamps
    end
  end
end
