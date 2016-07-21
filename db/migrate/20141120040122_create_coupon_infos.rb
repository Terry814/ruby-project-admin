class CreateCouponInfos < ActiveRecord::Migration
  def change
    create_table :coupon_infos do |t|
      t.string :title
      t.string :description
      t.date :expiry_date
      t.references :coupons, index: true

      t.timestamps
    end
  end
end
