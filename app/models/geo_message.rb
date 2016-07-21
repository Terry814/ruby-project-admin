# == Schema Information
#
# Table name: geo_messages
#
#  id                    :integer          not null, primary key
#  message               :string(255)
#  start_time            :datetime
#  end_time              :datetime
#  created_at            :datetime
#  updated_at            :datetime
#  one_time_notification :boolean          default(FALSE)
#  fire_on               :integer          default(0)
#  latitude              :float
#  longitude             :float
#  application_info_id   :integer
#
# Indexes
#
#  index_geo_messages_on_application_info_id  (application_info_id)
#

class GeoMessage < ActiveRecord::Base
  belongs_to :application_info, touch: true
  enum fire_on: %w(entry exit)

  validates_presence_of :message, :fire_on, :latitude, :longitude
  validates_existence_of :application_info, both: false
  validates :start_time, allow_blank: true,
    date: { after_or_equal_to: Proc.new { Date.current } }
  validates :end_time, allow_blank: true,
      date: { after: :start_time }, if: -> { start_time.present? }
  validates :end_time, allow_blank: true,
      date: { after_or_equal_to: Proc.new { Date.current } },
      if: -> { start_time.blank? }

  scope :current, (lambda do
    predicates = [
      'start_time <= :current_time AND end_time > :current_time',
      'start_time <= :current_time AND end_time IS NULL',
      'start_time IS NULL AND end_time > :current_time',
      'start_time IS NULL and end_time IS NULL',
    ]
    where([predicates.join(" OR "), current_time: Time.current])
  end)
end
