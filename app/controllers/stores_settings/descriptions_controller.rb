class StoresSettings::DescriptionsController < StoresSettings::BaseController
  before_action :set_app_stores_info

  def update_ios
    @app_stores_info.updating_ios = true
    respond_to do |format|
      if @app_stores_info.update(appstore_ios_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
  end

  def update_android
    @app_stores_info.updating_android = true
    respond_to do |format|
      if @app_stores_info.update(appstore_android_params)
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

  def set_app_stores_info
    @app_stores_info = current_application.app_stores_info
  end

  def appstore_ios_params
    params.require(:app_stores_info).permit(:ios_app_name, :ios_icon_label, :ios_first_category, :ios_second_category, :ios_description)
  end

  def appstore_android_params
    params.require(:app_stores_info).permit(:android_app_name, :android_icon_label, :android_first_category, :android_second_category, :android_description)
  end
end