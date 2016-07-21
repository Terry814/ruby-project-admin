class AppSettings::MenuCoverImagesController < AppSettings::BaseController
  before_action :set_application_info

  def create
    respond_to do |format|
      if @app_info.update(cover_image_params)
        format.html { redirect_to action: :show }
        format.json { render json: { message: "success" }, status: 200 }
      else
        format.html { render :show }
        format.json { render json: { error: @app_info.errors.full_messages.join(',')}, status: 400 }
      end
    end
  end

  def update
    respond_to do |format|
      if @app_info.update(cover_image_style_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        format.html { render :show }
      end
      format.js { render nothing: true }
    end
  end

  def destroy
    @app_info.cover_image = nil
    respond_to do |format|
      if @app_info.save
        format.html { redirect_to action: :show, status: 303 }
        format.json { render json: { message: "success" }, status: 200 }
      else
        format.html { render :show }
        format.json { render json: { error: @app_info.errors.full_messages.join(',')}, status: 400 }
      end
    end
  end

  private

  def set_application_info
    @app_info = current_application
  end

  def cover_image_params
    params.require(:application_info).permit(:cover_image)
  end

  def cover_image_style_params
    params.require(:application_info).permit(:cover_image_style)
  end
end