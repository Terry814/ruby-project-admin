# == Schema Information
#
# Table name: contact_us_infos
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class ContactUsInfo < ActiveRecord::Base
  include MenuItemInfoObject

  has_many :contact_locations, dependent: :destroy

  def menu_type
    'contacts'
  end
end
