module GeoMessageHelper
  def time_frame_string geo_message
    type_str = geo_message.one_time_notification ? "one time when" : "every time"
    fire_on_str = geo_message.entry? ? "enters" : "exits"
    since = geo_message.start_time
    untill = geo_message.end_time
    if since.present? and untill.present?
      "will be sent #{type_str} user #{fire_on_str} location from #{since.to_s(:long_12)} until #{untill.to_s(:long_12)}"
    elsif since.present?
      "will be sent #{type_str} user #{fire_on_str} location starting from #{since.to_s(:long_12)}"
    elsif untill.present?
      "will be sent #{type_str} user #{fire_on_str} location until #{untill.to_s(:long_12)}"
    else
      "will be sent #{type_str} user #{fire_on_str} location"
    end
  end

  def location_link geo_message
    link_to("http://maps.google.com/maps?q=#{geo_message.latitude},#{geo_message.longitude}", target: "blank") do
      "#{geo_message.latitude}, #{geo_message.longitude}"
    end
  end
end
