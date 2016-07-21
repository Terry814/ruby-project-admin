json.cache! ['api', 'v1', @app_info, 'config'] do
  json.updated_at @app_info.updated_at.to_i
  json.ad_frequency @app_info.ad_frequency
  json.has_geo_messages @app_info.geo_messages.any?
  json.menus @app_info.menu_items.enabled do |menu_item|
    json.cache! ['api', 'v1', menu_item] do
      json.type menu_item.info_object.menu_type
      json.(menu_item, :display_name, :position, :app_home, :id)
      case menu_item.info_object
      when WebLink
        json.url menu_item.info_object.url
      when OpenTable
        json.url menu_item.info_object.url
      when Shopify
        json.url menu_item.info_object.url
      when PdfFileItem
        json.url menu_item.info_object.pdf_file.url
      when SocialStream
        json.accounts menu_item.info_object.social_source_accounts do |acc|
          json.(acc, :id, :service)
          case
          when acc.hashtag.present?
            json.hashtag acc.hashtag
          when acc.facebook?, acc.instagram?
            json.user_id acc.service_user_id.to_s
          when acc.twitter? && acc.list_name.present?
            json.list_owner acc.username
            json.list_name acc.list_name
          when acc.twitter?, acc.youtube?
            json.username acc.username
          end
        end
      when ProductMenu
        json.products menu_item.info_object.categories do |cat|
          json.category_id cat.id
          json.category_name cat.name
          json.category_position cat.position
          json.category_items cat.product_menu_items do |i|
            json.(i, :id, :name, :price, :description)
            json.image_url i.image.url
            json.position i.position
          end
        end
      when Coupons
        json.coupons menu_item.info_object.coupon_infos do |c|
          json.id c.id.to_s
          json.(c, :title, :description, :expiry_date)
          json.expiry_date c.expiry_datetime.to_s(:iso8601)
          json.image_url c.image.url
        end
      when ContactUsInfo
        json.contacts menu_item.info_object.contact_locations do |loc|
          json.(loc, :name, :email, :id)
          json.address1 loc.street_line_one
          json.address2 loc.street_line_two
          json.phone loc.phone_number
          json.(loc, :latitude, :longitude)
          json.image_url loc.image.url
          json.position loc.position
        end
      when CustomerFeedback
        json.feedback_options do
          json.(menu_item.info_object, :yelp_url, :trip_advisor_url)
          json.sorry_threshold menu_item.info_object.message_threshold
          json.sorry_text menu_item.info_object.message
          json.email_to menu_item.info_object.email
        end
      end
    end
  end
  json.cover_image @app_info.cover_image.url(:retina)
  json.cover_image_style @app_info.cover_image_style
  json.colors do
    json.navigation_bar do
      json.bar_color @app_info.app_colors.header_bg_color
      json.elements_color @app_info.app_colors.header_text_color
    end
    json.menu_top do
      json.bg_color @app_info.app_colors.menu_top_bg_color
      json.text_color @app_info.app_colors.menu_top_text_color
    end
    json.menu do
      json.bg_color @app_info.app_colors.header_bg_color
      json.selected_indicator_color @app_info.app_colors.header_bg_color
      json.seperator_color @app_info.app_colors.separator_color
      json.seperator_accent_color @app_info.app_colors.separator_accent_color
      json.cell_bg_color @app_info.app_colors.menu_cell_bg_color
      json.text_color @app_info.app_colors.menu_cell_text_color
    end
  end
end