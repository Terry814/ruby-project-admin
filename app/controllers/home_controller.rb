class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tasks
  before_action :set_stats_if_published

  def index
  end

  private

  def set_tasks
    @tasks = current_user.tasks
  end

  def set_stats_if_published
    return if !current_application.published_to_stores?
    @has_card_info = current_user.has_card_info?
    asi = current_application.app_stores_info
    @ready_status = asi.valid_for_itunes? && asi.valid_for_play_market? && @has_card_info
    @today_total = today_installs_count
    @today_ios_installs_count = today_installs_count 'ios'
    @today_total = [@today_total, @today_ios_installs_count].max
    @today_android_installs_count = @today_total - @today_ios_installs_count
    @weekly_installs = last_week_installs @today_total
    @weekly_installs << AppInstalls.new(as_of_day: Date.current, total: @today_total)
  end

  def today_installs_count platform = nil, if_error_count = 0
    installs = AppInstalls.fetch_installs_from_parse(current_application, Date.current, platform)
    return if_error_count if installs.nil?
    installs.total
  end

  def last_week_installs today_total
    oldest_date = 7.days.ago.to_date
    installs = current_application.app_installs.where({as_of_day: oldest_date..Date.current}).to_a
    ret = []
    6.downto(1) do |days_ago|
      as_of_day = days_ago.days.ago.to_date
      day_install = installs.find {|i| i.as_of_day.eql? as_of_day}
      unless day_install
        day_install = if today_total <= 1
                        AppInstalls.new(as_of_day: as_of_day, total: 0)
                      else
                        AppInstalls.fetch_installs_from_parse(current_application, as_of_day)
                      end
        day_install.save if day_install
      end
      ret << day_install if day_install
    end
    ret
  end
end
