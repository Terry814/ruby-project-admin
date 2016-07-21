# == Schema Information
#
# Table name: autopost_connections
#
#  id          :integer          not null, primary key
#  autopost_id :integer
#  identity_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_autopost_connections_on_autopost_id  (autopost_id)
#  index_autopost_connections_on_identity_id  (identity_id)
#

class AutopostConnection < ActiveRecord::Base
  belongs_to :autopost
  belongs_to :identity

  validates_existence_of :autopost, both: false
  validates_existence_of :identity, both: false
end
