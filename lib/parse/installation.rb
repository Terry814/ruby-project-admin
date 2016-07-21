module Parse
  class Installation
    attr_accessor :channels
    attr_accessor :device_type
    attr_accessor :query

    HEADERS = {"Content-Type" => "application/x-www-form-urlencoded"}

    def initialize query = {}
      raise ArgumentError, 'Query must an object which responds to #to_hash' unless query.respond_to?(:to_hash)
      @query = query
    end

    def where
      if @channels.kind_of? Array
        @channels = if @channels.count == 1
          @channels.first
        else
          {"$all" => @channels}
        end
      end
      q = {
        channels: @channels,
        deviceType: @device_type
      }
      q.merge(@query).compact.to_json
    end

    def get_count
      body = {
        where: where,
        count: 1,
        limit: 0
      }
      HttpClient.get('/installations', body: body, headers: HEADERS)
    end
  end
end