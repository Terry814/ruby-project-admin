class AppSettings::ColorsController < AppSettings::BaseController
  before_action :set_colors

  def update
    respond_to do |format|
      if @colors.update(colors_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
  end

  private

  def set_colors
    @colors = current_application.app_colors
  end

  def colors_params
    params.require(:app_colors).permit(:header_bg_color, :header_text_color, :separator_color, :separator_accent_color, :menu_cell_bg_color, :menu_cell_text_color, :menu_top_bg_color, :menu_top_text_color)
  end
end