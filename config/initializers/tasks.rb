class TaskGroup
  include Enumerable

  def initialize
    @tasks = []
  end

  def << task
    @tasks << task
  end

  def each
    if block_given?
      @tasks.each { |t| yield(t) }
    else
      Enumerator.new(self)
    end
  end 
end

class Task
  attr_reader :name, :url, :copy
  attr_reader :badge

  def initialize(name, badge = nil, url = nil, copy = nil, &block)
    @name, @badge, @url, @copy = name, badge, url, copy
    @block = block
  end

  def completed?(user)
    @block.call user
  end
end

initial = TaskGroup.new
initial << Task.new("Menu Setup", "fa-bars", 'app_settings_menu_path', 'Manage the order of the items in your menu, and set your app\'s home screen.') do |user|
  user.application_info.updated_menu
end
initial << Task.new("Menu Cover Image", 'fa-picture-o', 'app_settings_menu_cover_image_path', 'Change the header image of your app\'s menu to add branding to the look and feel of your app.') do |user|
  user.application_info.cover_image.exists?
end
initial << Task.new("Menu Links", 'fa-link', 'app_settings_web_links_path', 'Add, remove and edit links to web content within your app.') do |user|
  WebLink.of_app(user.application_info).any?
end
initial << Task.new("Social Stream", 'fa-comments', 'app_settings_social_streams_path', 'Set the accounts from Facebook, Instagram, Twitter, and YouTube to drive your social stream.') do |user|
  SocialStream.first_of_app_or_initialize(user.application_info).persisted?
end
initial << Task.new("Colors", 'fa-tint', 'app_settings_colors_path', 'Customize the colors of your header and menu to match your brand and web content.') do |user|
  colors = user.application_info.app_colors
  colors.created_at != colors.updated_at
end
initial << Task.new("Description", 'fa-tags', 'stores_settings_description_path', 'Create your app store descriptions that will make mobile users interested in downloading your app.') do |user|
  app_stores_info = user.application_info.app_stores_info
  not(app_stores_info.nil?) and not(app_stores_info.ios_description.nil? and app_stores_info.android_description.nil?)
end
initial << Task.new("Icon", 'fa-bookmark', 'stores_settings_app_icon_path', 'Upload your mobile icon to be shown in app stores and on the phone\'s home screen.') do |user|
  user.application_info.app_stores_info.app_icon.exists?
end
initial << Task.new("Screenshots", 'fa-camera-retro', 'stores_settings_screenshots_path', 'Upload the images that will showcase your app in Apple iTunes and Google Play.') do |user|
  0 != user.application_info.app_stores_info.app_screenshots.size
end
initial << Task.new("Select Your Account Package", 'fa-th-large', 'accounts_appease_packages_path', 'Choose your level of service for your app and unlock additional features from AppEase.') do |user|
  not user.current_package.nil?
end
initial << Task.new("Enter Your Billing Info", 'fa-usd', 'accounts_billing_info_path', 'Set up your billing info. We won\'t charge you until your app is published.') do |user|
  user.has_card_info?
end

Rails.configuration.initial_tasks = initial
