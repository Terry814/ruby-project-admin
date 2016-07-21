module Parse
  class HttpClient
    include HTTParty
    base_uri 'https://api.parse.com/1'
    headers "X-Parse-Application-Id" => ENV['PARSE_APP_ID']
    headers "X-Parse-REST-API-Key" => ENV['PARSE_REST_API_KEY']
    headers "X-Parse-Master-Key" => ENV['PARSE_MASTER_KEY']
    headers "Content-Type" => "application/json"
  end
end