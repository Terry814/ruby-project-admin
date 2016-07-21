class CreateCustomerFeedbacks < ActiveRecord::Migration
  def change
    create_table :customer_feedbacks do |t|
      t.boolean :enabled, default: false
      t.string :email
      t.string :trip_advisor_url
      t.string :yelp_url
      t.text :message, limit: nil
      t.integer :message_threshold, default: 3

      t.timestamps
    end
  end
end
