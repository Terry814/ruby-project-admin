class RenamePositionWeightColumnOnMenuItem < ActiveRecord::Migration
  def change
    rename_column :menu_items, :position_weight, :position
  end
end
