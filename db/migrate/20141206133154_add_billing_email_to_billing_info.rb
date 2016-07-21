class AddBillingEmailToBillingInfo < ActiveRecord::Migration
  def change
    add_column :billing_infos, :email, :string
  end
end
