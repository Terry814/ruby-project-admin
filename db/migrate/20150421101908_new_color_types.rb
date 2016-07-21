class NewColorTypes < ActiveRecord::Migration
  def change
    add_column    :app_colors, :separator_accent_color, :string, default: '#1b1b1b'
    add_column    :app_colors, :menu_cell_bg_color, :string, default: '#202020'
    add_column    :app_colors, :menu_cell_text_color, :string, default: '#eeeeee'
    rename_column :app_colors, :bg_color, :header_bg_color
    rename_column :app_colors, :text_color, :header_text_color
    change_column_default :app_colors, :header_bg_color, '#1d1d1d'
  end
end
