# == Schema Information
#
# Table name: social_streams
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class SocialStream < ActiveRecord::Base
  include MenuItemInfoObject

  has_many :social_source_accounts, dependent: :destroy

  def menu_type
    'social'
  end
end
