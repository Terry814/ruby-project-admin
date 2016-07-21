class CreateSocialSourceAccounts < ActiveRecord::Migration
  def change
    create_table :social_source_accounts do |t|
      t.integer :service
      t.integer :user_id
      t.string :username
      t.string :list_name
      t.references :social_stream, index: true

      t.timestamps
    end
    add_index :social_source_accounts, :service
  end
end
