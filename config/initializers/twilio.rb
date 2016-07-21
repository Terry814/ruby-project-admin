Twilio.configure do |config|
  config.account_sid = ENV['TWILIO_ACCOUNT_SID'] || 'AC8a540cdd270f41e9e71332921998fd12'
  config.auth_token = ENV['TWILIO_AUTH_TOKEN'] || '797c3616b926f96f16eafb36c300f31d'
end
