class ChangeIdentityProviderTypeToInt < ActiveRecord::Migration
  def self.up
    providers = %w(facebook twitter instagram)
    add_column :identities, :int_provider, :integer

    Identity.find_each { |i| i.update_columns(int_provider: providers.index(i.provider)) }

    remove_column :identities, :provider
    rename_column :identities, :int_provider, :provider
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
