class AddSubscriptionCancelledAtToBillingInfos < ActiveRecord::Migration
  def change
    add_column :billing_infos, :subscription_cancelled_at, :datetime
  end
end
