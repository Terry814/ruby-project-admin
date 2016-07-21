class AddMenuTopColorsToAppColors < ActiveRecord::Migration
  def change
    add_column :app_colors, :menu_top_bg_color, :string, default: '#1d1d1d'
    add_column :app_colors, :menu_top_text_color, :string, default: '#fafafa'
  end
end
