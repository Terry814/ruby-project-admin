# == Schema Information
#
# Table name: autopost_social_source_accounts
#
#  id                       :integer          not null, primary key
#  autopost_id              :integer
#  social_source_account_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#
# Indexes
#
#  index_autopost_social_source_accounts_id              (social_source_account_id)
#  index_autopost_social_source_accounts_on_autopost_id  (autopost_id)
#

class AutopostSocialSourceAccount < ActiveRecord::Base
  belongs_to :autopost
  belongs_to :social_source_account

  validates_existence_of :autopost, both: false
  validates_existence_of :social_source_account, both: false
end
