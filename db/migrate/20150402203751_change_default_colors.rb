class ChangeDefaultColors < ActiveRecord::Migration
  def change
    change_column_default :app_colors, :bg_color, "#202020"
    change_column_default :app_colors, :separator_color, "#272727"
    change_column_default :app_colors, :text_color, "#FAFAFA"
  end
end
