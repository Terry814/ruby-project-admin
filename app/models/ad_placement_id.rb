# == Schema Information
#
# Table name: ad_placement_ids
#
#  id           :integer          not null, primary key
#  placement_id :string(255)
#  platform     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class AdPlacementId < ActiveRecord::Base
  enum platform: %w(ios android)
  validates_presence_of :placement_id, :platform

  scope :ios_ads, -> { where(platform: AdPlacementId.platforms['ios']) }
  scope :android_ads, -> { where(platform: AdPlacementId.platforms['android']) }
end
