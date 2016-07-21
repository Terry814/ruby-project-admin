class CreateBillingInfos < ActiveRecord::Migration
  def change
    create_table :billing_infos do |t|
      t.string :card_last_four
      t.string :stripe_card_token
      
      t.string :stripe_customer_id
      t.string :stripe_subscription_id

      t.references :user, index: true

      t.timestamps
    end
  end
end
