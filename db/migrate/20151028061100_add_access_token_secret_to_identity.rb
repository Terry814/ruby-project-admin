class AddAccessTokenSecretToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :access_token_secret, :string
  end
end
