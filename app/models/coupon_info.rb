# == Schema Information
#
# Table name: coupon_infos
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  description        :string(255)
#  expiry_date        :date
#  coupons_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#
# Indexes
#
#  index_coupon_infos_on_coupons_id  (coupons_id)
#

class CouponInfo < ActiveRecord::Base
  belongs_to :coupons, touch: true

  has_attached_file :image, preserve_files: true

  validates_presence_of :title, :expiry_date
  validates_existence_of :coupons, both: false
  validates :expiry_date, date: { after_or_equal_to: Proc.new { Date.current } }
  validates_attachment :image, content_type: 
          { content_type: ["image/jpeg", "image/png"] }
  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/]

  def expiry_datetime
    expiry_date.end_of_day
  end
end
