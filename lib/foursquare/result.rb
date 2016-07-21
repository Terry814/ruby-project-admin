module Foursquare
  class Result
    attr_reader :data
    attr_reader :error

    def initialize(data, error = nil)
      @data, @error = data, error
    end

    def ok?
      @error.nil?
    end
  end
end