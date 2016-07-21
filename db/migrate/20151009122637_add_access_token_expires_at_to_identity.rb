class AddAccessTokenExpiresAtToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :access_token, :string
    add_column :identities, :expires_at, :datetime
  end
end
