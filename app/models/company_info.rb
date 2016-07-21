class CompanyInfo
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  attr_accessor :name, :web_link
  attr_accessor :street, :city, :state, :postal_code
  attr_accessor :twitter, :open_table_link, :phone

  validates_presence_of :name, :city, :state

  def full_address
    ret = [@city, @state].join(' ').strip
    ret = @street + ", " + ret if @street.present?
    ret += ", " + @postal_code if @postal_code.present?
    ret
  end
  
  def venue_data= venue
    @web_link = venue.url if @web_link.blank?
    @street = venue.address if venue.address.present?
    [:city, :state, :postal_code].each do |attr|
      send("#{attr}=", venue.public_send(attr)) if venue.public_send(attr).present?
    end
    [:twitter, :open_table_link, :phone].each do |attr|
      send("#{attr}=", venue.public_send(attr))
    end
  end
end