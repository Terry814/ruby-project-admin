module OneSignal
  class HttpClient
    include HTTParty
    base_uri "https://onesignal.com/api/v1"

    headers "Content-Type" => "application/json"
    headers "Authorization" => "Basic #{ENV['ONESIGNAL_USER_AUTH_KEY']}"
  end
end
