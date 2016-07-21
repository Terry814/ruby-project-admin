module SocialAccountHelper
  def social_account_display_name acc
    return "##{acc.hashtag}" if acc.hashtag.present?

    case
    when acc.twitter? && acc.list_name.present?
      "List #{acc.list_name} of @#{acc.username}"
    when acc.instagram?, acc.twitter? then "@#{acc.username}"
    when acc.facebook?, acc.youtube?  then acc.username
    end
  end

  def social_account_url acc
    case
    when acc.facebook?
      "https://www.facebook.com/#{acc.username}"
    when acc.twitter? && acc.list_name.present?
      "https://twitter.com/#{acc.username}/lists/#{acc.list_name}"
    when acc.twitter? && acc.hashtag.present?
      "https://twitter.com/hashtag/#{acc.hashtag}"
    when acc.twitter?
      "https://twitter.com/#{acc.username}"
    when acc.instagram? && acc.hashtag.present?
      "https://instagram.com/explore/tags/#{acc.hashtag}"
    when acc.instagram?
      "http://instagram.com/#{acc.username}"
    when acc.youtube?
      "https://www.youtube.com/user/#{acc.username}"
    end
  end
end