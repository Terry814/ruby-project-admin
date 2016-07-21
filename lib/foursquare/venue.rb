module Foursquare
  class Venue
    attr_reader :id
    attr_reader :name
    attr_reader :address, :city, :state, :postal_code
    attr_reader :has_menu
    attr_reader :phone, :twitter, :url
    attr_reader :open_table_link

    def initialize(dic = {})
      @id = dic['id']
      @name = dic['name']
      @has_menu = dic['hasMenu'] == true
      @open_table_link = dic['reservations']['url'] if dic['reservations']
      @url = dic['url']
      location = dic['location']
      if location
        @address = location['address']
        @city = location['city']
        @state = location['state']
        @postal_code = location['postalCode']
      end
      contacts = dic['contact']
      if contacts
        @phone = contacts['phone']
        @twitter = contacts['twitter']
      end
    end

    def full_address
      full_city = [@city, @state].join(' ')
      if @address && !@address.empty?
        "#{@address}, #{full_city}"
      else
        full_city
      end
    end
  end
end