# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160225111817) do

  create_table "ad_placement_ids", force: true do |t|
    t.string   "placement_id"
    t.integer  "platform"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_colors", force: true do |t|
    t.integer  "application_info_id"
    t.string   "header_bg_color",        default: "#1d1d1d"
    t.string   "separator_color",        default: "#272727"
    t.string   "header_text_color",      default: "#FAFAFA"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "separator_accent_color", default: "#1b1b1b"
    t.string   "menu_cell_bg_color",     default: "#202020"
    t.string   "menu_cell_text_color",   default: "#eeeeee"
    t.string   "menu_top_bg_color",      default: "#1d1d1d"
    t.string   "menu_top_text_color",    default: "#fafafa"
  end

  add_index "app_colors", ["application_info_id"], name: "index_app_colors_on_application_info_id"

  create_table "app_installs", force: true do |t|
    t.integer  "total"
    t.date     "as_of_day"
    t.integer  "application_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_installs", ["application_info_id"], name: "index_app_installs_on_application_info_id"

  create_table "app_screenshots", force: true do |t|
    t.integer  "app_stores_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "app_screenshots", ["app_stores_info_id"], name: "index_app_screenshots_on_app_stores_info_id"

  create_table "app_stores_infos", force: true do |t|
    t.string   "ios_app_name"
    t.string   "ios_icon_label"
    t.string   "ios_first_category"
    t.string   "ios_second_category"
    t.text     "ios_description"
    t.string   "android_app_name"
    t.string   "android_icon_label"
    t.string   "android_first_category"
    t.string   "android_second_category"
    t.text     "android_description"
    t.integer  "application_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app_icon_file_name"
    t.string   "app_icon_content_type"
    t.integer  "app_icon_file_size"
    t.datetime "app_icon_updated_at"
    t.string   "itunes_link"
    t.string   "play_market_link"
  end

  add_index "app_stores_infos", ["application_info_id"], name: "index_app_stores_infos_on_application_info_id"

  create_table "application_infos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "cover_image_file_name"
    t.string   "cover_image_content_type"
    t.integer  "cover_image_file_size"
    t.datetime "cover_image_updated_at"
    t.string   "app_id_suffix"
    t.boolean  "updated_menu",             default: false
    t.boolean  "json_fetched_by_preview",  default: false
    t.datetime "last_published_at"
    t.boolean  "json_fetched_by_instant",  default: false
    t.integer  "cover_image_style",        default: 0
    t.integer  "ad_frequency",             default: 0
    t.string   "onesignal_app_id"
    t.string   "onesignal_app_key"
  end

  add_index "application_infos", ["user_id"], name: "index_application_infos_on_user_id"

  create_table "autolikes", force: true do |t|
    t.boolean  "enabled"
    t.text     "hashtags"
    t.integer  "application_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latest_id"
  end

  add_index "autolikes", ["application_info_id"], name: "index_autolikes_on_application_info_id"

  create_table "autopost_connections", force: true do |t|
    t.integer  "autopost_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "autopost_connections", ["autopost_id"], name: "index_autopost_connections_on_autopost_id"
  add_index "autopost_connections", ["identity_id"], name: "index_autopost_connections_on_identity_id"

  create_table "autopost_social_source_accounts", force: true do |t|
    t.integer  "autopost_id"
    t.integer  "social_source_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "autopost_social_source_accounts", ["autopost_id"], name: "index_autopost_social_source_accounts_on_autopost_id"
  add_index "autopost_social_source_accounts", ["social_source_account_id"], name: "index_autopost_social_source_accounts_id"

  create_table "autoposts", force: true do |t|
    t.boolean  "enabled",             default: false
    t.integer  "interval",            default: 1800
    t.boolean  "randomized",          default: false
    t.string   "hashtag"
    t.string   "url"
    t.integer  "application_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "autoposts", ["application_info_id"], name: "index_autoposts_on_application_info_id"

  create_table "billing_infos", force: true do |t|
    t.string   "card_last_four"
    t.string   "stripe_card_token"
    t.string   "stripe_customer_id"
    t.string   "stripe_subscription_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "card_brand"
    t.datetime "subscription_cancelled_at"
  end

  add_index "billing_infos", ["user_id"], name: "index_billing_infos_on_user_id"

  create_table "contact_locations", force: true do |t|
    t.string   "name"
    t.string   "street_line_one"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "email"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_us_info_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "position",           default: 0
  end

  add_index "contact_locations", ["contact_us_info_id"], name: "index_contact_locations_on_contact_us_info_id"

  create_table "contact_us_infos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_infos", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.date     "expiry_date"
    t.integer  "coupons_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "coupon_infos", ["coupons_id"], name: "index_coupon_infos_on_coupons_id"

  create_table "coupons", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_feedbacks", force: true do |t|
    t.string   "email"
    t.string   "trip_advisor_url"
    t.string   "yelp_url"
    t.text     "message"
    t.integer  "message_threshold", default: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geo_messages", force: true do |t|
    t.string   "message"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "one_time_notification", default: false
    t.integer  "fire_on",               default: 0
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "application_info_id"
  end

  add_index "geo_messages", ["application_info_id"], name: "index_geo_messages_on_application_info_id"

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.integer  "provider",            limit: 255
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
    t.datetime "expires_at"
    t.string   "access_token_secret"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id"

  create_table "invoice_lines", force: true do |t|
    t.string   "description"
    t.float    "amount"
    t.integer  "invoice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_lines", ["invoice_id"], name: "index_invoice_lines_on_invoice_id"

  create_table "invoices", force: true do |t|
    t.date     "date"
    t.string   "description"
    t.float    "total"
    t.integer  "billing_info_id"
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoices", ["billing_info_id"], name: "index_invoices_on_billing_info_id"

  create_table "menu_items", force: true do |t|
    t.string   "display_name"
    t.integer  "position",            default: 0
    t.boolean  "app_home",            default: false
    t.integer  "application_info_id"
    t.integer  "info_object_id"
    t.string   "info_object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",             default: false
  end

  add_index "menu_items", ["application_info_id"], name: "index_menu_items_on_application_info_id"
  add_index "menu_items", ["info_object_id", "info_object_type"], name: "index_menu_items_on_info_object_id_and_info_object_type"

  create_table "open_tables", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pdf_file_items", force: true do |t|
    t.string   "pdf_file_file_name"
    t.string   "pdf_file_content_type"
    t.integer  "pdf_file_file_size"
    t.datetime "pdf_file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_menu_categories", force: true do |t|
    t.string   "name"
    t.integer  "position",        default: 0
    t.integer  "product_menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_menu_categories", ["product_menu_id"], name: "index_product_menu_categories_on_product_menu_id"

  create_table "product_menu_items", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.float    "price"
    t.integer  "product_menu_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "position",                 default: 0
  end

  add_index "product_menu_items", ["product_menu_category_id"], name: "index_product_menu_items_on_product_menu_category_id"

  create_table "product_menus", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shopifies", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_source_accounts", force: true do |t|
    t.integer  "service"
    t.string   "username"
    t.string   "list_name"
    t.integer  "social_stream_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hashtag"
    t.string   "service_user_id"
  end

  add_index "social_source_accounts", ["service"], name: "index_social_source_accounts_on_service"
  add_index "social_source_accounts", ["social_stream_id"], name: "index_social_source_accounts_on_social_stream_id"

  create_table "social_streams", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "company_name"
    t.string   "full_name"
    t.string   "email",                    default: "",   null: false
    t.string   "encrypted_password",       default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "subscribed_to_emails",     default: true
    t.integer  "current_package",          default: 0
    t.integer  "sign_up_method",           default: 0
    t.string   "phone_number"
    t.datetime "last_changed_password_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "web_links", force: true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
