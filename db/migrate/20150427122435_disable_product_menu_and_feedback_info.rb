class DisableProductMenuAndFeedbackInfo < ActiveRecord::Migration
  def up
    ApplicationInfo.no_touching do
      MenuItem.where(info_object_type: ProductMenu).find_each { |mi| mi.update(enabled: false) }
      MenuItem.where(info_object_type: CustomerFeedback).find_each { |mi| mi.update(enabled: false) }
    end
    ApplicationInfo.find_each { |app| app.touch }
  end

  def down
  end
end
