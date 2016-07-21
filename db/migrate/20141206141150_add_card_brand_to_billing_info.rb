class AddCardBrandToBillingInfo < ActiveRecord::Migration
  def change
    add_column :billing_infos, :card_brand, :string
  end
end
