module SocialLinkHelper
  def social_account? link
    get_username_or_id(link).present?
  end

  def get_username_or_id link
    return unless link.instance_of?(String)
    case URI(link).host
    when /instagram/
      get_instagram_username link
    when /twitter/
      get_twitter_username link
    when /facebook/
      get_facebook_username link
    end
  end

  INSTAGRAM_REGEX = 'https?:\/\/(www\.)?instagram\.com\/([^\/\?]*)\/?$'
  def get_instagram_username link
    regex_match INSTAGRAM_REGEX, link, 2
  end

  FB_REGEX = 'https?:\/\/(www\.)?facebook\.com\/((\w)*#!\/)?(pages\/)?([\w\-]*\/)*([\w\-\.]*)'
  def get_facebook_username link
    regex_match FB_REGEX, link, 6
  end

  TWITTER_REGEX = 'https?:\/\/(www\.)?twitter\.com\/(#!\/)?@?([^\/\?]*)\/?$'
  def get_twitter_username link
    regex_match TWITTER_REGEX, link, 3
  end

  def regex_match regex_str, str, index
    match = Regexp.new(regex_str).match(str)
    match[index] if match
  end
end