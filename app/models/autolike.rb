# == Schema Information
#
# Table name: autolikes
#
#  id                  :integer          not null, primary key
#  enabled             :boolean
#  hashtags            :text
#  application_info_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#  latest_id           :string(255)
#
# Indexes
#
#  index_autolikes_on_application_info_id  (application_info_id)
#

require 'sidekiq/api'

class Autolike < ActiveRecord::Base
  INTERVAL = 15.minutes

  serialize :hashtags, Array
  belongs_to :application_info

  after_save :update_schedule, if: :enabled_changed?

  before_validation :remove_hashtag_symbol

  validates_existence_of :application_info, both: false

  private

  def remove_hashtag_symbol
    if hashtags.present?
      self.hashtags = hashtags.map { |h| h.delete '#' }
    end
    true
  end

  def update_schedule
    return if Rails.env.development?
    if enabled
      AutolikeWorker.perform_in(INTERVAL, id)
    else
      s = Sidekiq::ScheduledSet.new
      job = s.find { |job| job.args == [id] && job.queue == 'autolike' }
      job.try(:delete)
    end
  end
end
