module OneSignal
  class PushNotification
    ANDROID_APP_ID = "213ad6d3-22e4-492d-9a61-7c41c761f859"
    PREVIEWS_APP_ID = "cdf4c343-b858-4e65-880c-3a42d2ae3cc0"

    attr_reader :onesignal_app_id, :onesignal_app_key, :app_id, :alert
    attr_accessor :content_available, :data

    def initialize onesignal_app_id, onesignal_app_key, app_id, alert=""
      @onesignal_app_id = onesignal_app_id
      @onesignal_app_key = onesignal_app_key
      @app_id = app_id
      @alert = alert
      @content_available = false
    end

    def send
      HttpClient.post('/notifications', options_for(ANDROID_APP_ID, ENV['ONESIGNAL_ANDROID_APP_KEY']))
      if @onesignal_app_id.present? && @onesignal_app_key.present?
        HttpClient.post('/notifications', options_for(@onesignal_app_id, @onesignal_app_key))
      end
      HttpClient.post('/notifications', options_for(PREVIEWS_APP_ID, ENV['ONESIGNAL_PREVIEWS_APP_KEY']))
    end

    private

    def options_for os_id, os_key
      {
        body: {
          contents: {en: @alert},
          data: @data,
          content_available: @content_available,
          android_background_data: @content_available,
          app_id: os_id,
          tags: [key: "app_id", relation: "=", value: @app_id]
        }.compact.to_json,
        headers: {
          "Authorization" => "Basic #{os_key}"
        }
      }
    end
  end
end
