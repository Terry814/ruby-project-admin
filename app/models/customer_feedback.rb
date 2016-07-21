# == Schema Information
#
# Table name: customer_feedbacks
#
#  id                :integer          not null, primary key
#  email             :string(255)
#  trip_advisor_url  :string(255)
#  yelp_url          :string(255)
#  message           :text
#  message_threshold :integer          default(3)
#  created_at        :datetime
#  updated_at        :datetime
#

class CustomerFeedback < ActiveRecord::Base
  include MenuItemInfoObject

  MAX_THRESHOLD_STARS = 4

  attr_accessor :updating_info

  validates_format_of :email, :with => RFC822::EMAIL, allow_blank: true, :if => Proc.new { @updating_info }
  validates_presence_of :email, :if => Proc.new { @updating_info }
  validates_inclusion_of :message_threshold, in: 1..MAX_THRESHOLD_STARS

  def menu_type
    'feedback'
  end
end
