class ApplicationPopulateJob
  include SuckerPunch::Job

  def perform(company_info, application)
    SuckerPunch.logger.debug "Populating #{application} from 4square"
    @current_application = application
    @company_info = company_info

    ActiveRecord::Base.connection_pool.with_connection do
      ApplicationInfo.no_touching do
        set_social_stream
        populate_web_links
        populate_contacts
      end
      application.adjust_menu_items_for_package
    end
  end

  private

  def set_social_stream
    twitter = @company_info.twitter
    return if twitter.blank?
    
    social_stream = SocialStream.first_of_app_or_initialize @current_application
    if social_stream.new_record?
      social_stream.update(menu_item_attributes: {enabled: true, display_name: "Social Stream", app_home: true})
    end
    suppress(Exception) do
      user_id = twitter_client.user(twitter, skip_status: true).id
      social_stream.social_source_accounts.create(
        service: 'twitter',
        username: twitter,
        service_user_id: user_id
      )
    end
  end

  def populate_web_links
    if @company_info.web_link.present?
      web_link = WebLink.build_with_application_info @current_application
      web_link.update(url: @company_info.web_link, menu_item_attributes: {display_name: "Website"})
    end
    if @company_info.open_table_link.present?
      web_link = WebLink.build_with_application_info @current_application
      web_link.update(url: @company_info.open_table_link, menu_item_attributes: {display_name: "Make online reservation"})
    end
  end

  def populate_contacts
    needs = [:name, :city, :street]
    has = needs.map { |attr| @company_info.public_send(attr).present? }
    if !has.include?(false)
      contact_us_info = ContactUsInfo.first_of_app_or_initialize @current_application
      if contact_us_info.new_record?
        contact_us_info.update(menu_item_attributes: {enabled: true, display_name: "Contact Us"})
      end
      contact_us_info.contact_locations.create(
        name: @company_info.name, street_line_one: @company_info.street,
        city: @company_info.city, state: @company_info.state, 
        postal_code: @company_info.postal_code, phone_number: @company_info.phone
        )
    end
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key    = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      if ENV['TWITTER_BEARER_TOKEN'].present?
        config.bearer_token    = ENV['TWITTER_BEARER_TOKEN']
      end
    end
  end
end