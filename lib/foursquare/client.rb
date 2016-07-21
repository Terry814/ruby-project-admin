module Foursquare
  class Client
    include HTTParty
    base_uri 'https://api.foursquare.com/v2'
    default_params client_id: ENV['FOURSQUARE_CLIENT_ID'],
                   client_secret: ENV['FOURSQUARE_CLIENT_SECRET'],
                   v: 20141226,
                   m: 'foursquare'

    def self.search_venues name, near
      q = {
        query: name,
        near: near,
        limit: 50
      }
      res = get('/venues/search', query: q)
      if res.ok?
        hash = JSON.parse(res.body)
        venues_arr = hash['response']['venues']
        venues = venues_arr.map { |d| Venue.new(d) }
        Result.new(venues)
      else
        Result.new(nil, "We couldn't get venues, please try again")
      end
    end

    def self.get_venue venue_id
      res = get "/venues/#{venue_id}"
      if res.ok?
        hash = JSON.parse(res.body)
        Result.new(Venue.new(hash['response']['venue']))
      else
        Result.new(nil, "We couldn't get venue info")
      end
    end
  end
end