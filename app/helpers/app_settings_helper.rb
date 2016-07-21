module AppSettingsHelper
  def feedback_threshold_options
    max = CustomerFeedback::MAX_THRESHOLD_STARS
    choices = 1.upto(max).map do |star_number|
      ["Show custom message for #{star_number} #{"star".pluralize(star_number)} or lower", star_number]
    end
  end

  def cover_image_style_options
    ApplicationInfo.cover_image_styles.map do |name, val|
      label_name = name == 'plain' ? 'full screen' : name
      [label_name, name]
    end
  end
end
