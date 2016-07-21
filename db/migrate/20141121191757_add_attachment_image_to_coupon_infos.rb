class AddAttachmentImageToCouponInfos < ActiveRecord::Migration
  def self.up
    change_table :coupon_infos do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :coupon_infos, :image
  end
end
