# == Schema Information
#
# Table name: autoposts
#
#  id                  :integer          not null, primary key
#  enabled             :boolean          default(FALSE)
#  interval            :integer          default(1800)
#  randomized          :boolean          default(FALSE)
#  hashtag             :string(255)
#  url                 :string(255)
#  application_info_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_autoposts_on_application_info_id  (application_info_id)
#

require 'sidekiq/api'

class Autopost < ActiveRecord::Base
  belongs_to :application_info

  has_many :autopost_connections, dependent: :destroy
  has_many :identities, through: :autopost_connections
  has_many :autopost_social_source_accounts, dependent: :destroy
  has_many :social_source_accounts, through: :autopost_social_source_accounts

  after_save :update_schedule, if: :enabled_changed?

  before_validation :remove_hashtag_symbol

  INTERVAL_OPTIONS = [ 30.minutes, 60.minutes,
    2.hours, 4.hours, 8.hours, 12.hours, 24.hours ]

  validates_existence_of :application_info, both: false
  validates_inclusion_of :interval, in: INTERVAL_OPTIONS

  private

  def remove_hashtag_symbol
    if hashtag.present?
      hashtag.delete! '#'
    end
    true
  end

  def update_schedule
    if enabled
      AutopostRepostWorker.perform_in(interval.seconds, id)
    else
      s = Sidekiq::ScheduledSet.new
      job = s.find { |job| job.args == [id] && job.queue == 'autopost' }
      job.try(:delete)
    end
  end
end
