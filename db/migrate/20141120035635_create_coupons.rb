class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end
