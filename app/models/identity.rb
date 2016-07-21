# == Schema Information
#
# Table name: identities
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  provider            :integer
#  uid                 :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  access_token        :string(255)
#  expires_at          :datetime
#  access_token_secret :string(255)
#
# Indexes
#
#  index_identities_on_user_id  (user_id)
#

class Identity < ActiveRecord::Base
  enum provider: %w(facebook twitter instagram)

  belongs_to :user

  has_many :autopost_connections, dependent: :destroy

  validates_inclusion_of :provider, in: providers
  validates_presence_of :uid, :provider, :access_token
  validates_presence_of :access_token_secret, if: Proc.new { twitter? }
  validates :expires_at, date: { after_or_equal_to: Proc.new { Date.current }, allow_blank: true }

  validates_existence_of :user, both: false
  validates_uniqueness_of :provider, scope: :user
end
