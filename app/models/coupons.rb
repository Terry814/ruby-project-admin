# == Schema Information
#
# Table name: coupons
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Coupons < ActiveRecord::Base
  include MenuItemInfoObject
  
  has_many :coupon_infos, -> { order("expiry_date ASC") }, dependent: :destroy

  def menu_type
    'coupons'
  end
end
