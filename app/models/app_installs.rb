# == Schema Information
#
# Table name: app_installs
#
#  id                  :integer          not null, primary key
#  total               :integer
#  as_of_day           :date
#  application_info_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#
# Indexes
#
#  index_app_installs_on_application_info_id  (application_info_id)
#

class AppInstalls < ActiveRecord::Base
  belongs_to :application_info

  class << self
    def fetch_installs_from_parse app, day, platform = nil
      if day.today? && platform.nil?
        cache_result = today_cache_get app
        return app_install_for(app, day, cache_result) if cache_result
      end

      installation = Parse::Installation.new
      installation.channels = [app.channel_name]
      installation.device_type = platform
      installation.query = {
        createdAt: {
          "$lt" => to_js_date(day.end_of_day)
        }
      }

      parse_res = installation.get_count
      return nil unless parse_res.ok?
      count = JSON.parse(parse_res.body)['count']
      if day.today? && platform.nil?
        today_cache_set app, count
      end
      app_install_for app, day, count
    end

    def app_install_for app, day, total
      app.app_installs.build(as_of_day: day, total: total)
    end

    def today_cache_get app
      Rails.cache.fetch today_cache_key(app)
    end

    def today_cache_set app, total
      Rails.cache.write(today_cache_key(app), total, expires_in: 3.hours, race_condition_ttl: 10.minutes)
    end

    def today_cache_key app
      "today/app_installs/#{app.id}"
    end

    def to_js_date datetime
      {"__type" => "Date", "iso" => datetime.iso8601 }
    end
  end
end
