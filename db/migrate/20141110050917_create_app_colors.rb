class CreateAppColors < ActiveRecord::Migration
  def change
    create_table :app_colors do |t|
      t.references :application_info, index: true
      t.string :bg_color, default: "#333333"
      t.string :separator_color, default: "#FFFFFF"
      t.string :text_color, default: "#FFFFFF"

      t.timestamps
    end
  end
end
