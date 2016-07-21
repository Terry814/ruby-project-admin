class SetDefaultsOnAutopost < ActiveRecord::Migration
  def change
    change_column_default :autoposts, :enabled, false
    change_column_default :autoposts, :interval, 30.minutes
    change_column_default :autoposts, :randomized, false
  end
end
