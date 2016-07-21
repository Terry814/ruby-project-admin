class AddAdFrequencyToApplicationInfos < ActiveRecord::Migration
  def change
    add_column :application_infos, :ad_frequency, :integer, default: 0
  end
end
