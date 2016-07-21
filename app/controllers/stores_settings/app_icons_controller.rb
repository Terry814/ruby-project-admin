class StoresSettings::AppIconsController < StoresSettings::BaseController
  before_action :set_app_stores_info
  before_action :set_application_info

  def update
    respond_to do |format|
      if @app_stores_info.update(app_icon_param)
        format.html { redirect_to action: :show }
        format.json { render json: { message: "success" }, status: 200 }
      else
        format.html { render :show }
        format.json { render json: { error: @app_stores_info.errors.full_messages.join(',')}, status: 400 }
      end
    end
  end

  private
  
  def set_app_stores_info
    @app_stores_info = current_application.app_stores_info
  end

  def set_application_info
    @app_info = current_application
  end

  def app_icon_param
    params.require(:app_stores_info).permit(:app_icon)
  end
end