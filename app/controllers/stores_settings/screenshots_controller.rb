class StoresSettings::ScreenshotsController < StoresSettings::BaseController
  before_action :set_app_stores_info

  def create
    respond_to do |format|
      screenshot = @app_stores_info.app_screenshots.build
      if screenshot.update(screenshot_param)
        format.html { redirect_to action: :show }
        format.json { render json: { message: "success", 
                                    data: { id: screenshot.id } }, status: 200 }
      else
        format.html { render :show }
        format.json { render json: { error: screenshot.errors.full_messages.join(',')}, status: 400 }
      end
    end
  end

  def destroy
    screenshot = @app_stores_info.app_screenshots.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to action: :show, status: 303 }
      format.json { render json: { message: "success" }, status: 200 }
      format.js { render nothing: true }
    end
  end

  private

  def set_app_stores_info
    @app_stores_info = current_application.app_stores_info
  end

  def screenshot_param
    params.require(:screenshot).permit(:image)
  end
end