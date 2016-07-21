class AddSubscribedToEmailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscribed_to_emails, :boolean, default: false
  end
end
