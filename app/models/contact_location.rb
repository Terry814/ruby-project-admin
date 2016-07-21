# == Schema Information
#
# Table name: contact_locations
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  street_line_one    :string(255)
#  city               :string(255)
#  state              :string(255)
#  postal_code        :string(255)
#  email              :string(255)
#  phone_number       :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  contact_us_info_id :integer
#  latitude           :float
#  longitude          :float
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  position           :integer          default(0)
#
# Indexes
#
#  index_contact_locations_on_contact_us_info_id  (contact_us_info_id)
#

class ContactLocation < ActiveRecord::Base
  belongs_to :contact_us_info, touch: true
  acts_as_list scope: :contact_us_info

  geocoded_by :full_address
  phony_normalize :phone_number, default_country_code: 'US'
  has_attached_file :image, preserve_files: true

  validates_attachment :image, content_type:
          { content_type: ["image/jpeg", "image/png"] }
  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/]
  validates_presence_of :name, :city, :street_line_one
  validates_existence_of :contact_us_info, both: false
  validates_format_of :email, with: RFC822::EMAIL, allow_blank: true
  validates_plausible_phone :phone_number

  after_validation :geocode

  def full_address
    "#{street_line_one}, #{street_line_two}"
  end

  def google_maps_link
    "https://www.google.com/maps/@#{latitude},#{longitude},18z"
  end

  def street_line_two
    line = "#{city}"
    if state.present? || postal_code.present?
      line << ", #{[state, postal_code].join(' ')}"
    end
    line
  end
end
