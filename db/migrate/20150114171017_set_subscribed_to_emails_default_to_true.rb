class SetSubscribedToEmailsDefaultToTrue < ActiveRecord::Migration
  def up
    change_column_default :users, :subscribed_to_emails, true
    User.find_each { |u| u.update_columns(subscribed_to_emails: true) }
  end
  
  def down
    change_column_default :users, :subscribed_to_emails, false
  end
end
