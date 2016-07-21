class RemoveAtSignsFromStartsOfUsernames < ActiveRecord::Migration
  def up
    services = ['twitter', 'instagram']
    SocialSourceAccount.all.each do |acc|
      acc.update_attribute(:username, acc.username.delete('@')) if services.include?(acc.service)
    end
  end

  def down
  end
end
