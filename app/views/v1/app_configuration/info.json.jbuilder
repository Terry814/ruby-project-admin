json.company_name @app_owner.company_name
json.push_enabled @push_enabled
json.onesignal_app_id @app_info.onesignal_app_id
json.app_suffix @app_info.app_id_suffix
json.bundle_id "com.appease.#{@app_info.app_id_suffix}"
json.app_stores_info do
  json.ios_app_name @app_stores_info.ios_app_name
  json.android_app_name @app_stores_info.android_app_name
  json.app_icon_url @app_stores_info.app_icon.url
  json.screenshots do
    json.array! @app_stores_info.app_screenshots.map { |s| s.image.url }
  end
end
