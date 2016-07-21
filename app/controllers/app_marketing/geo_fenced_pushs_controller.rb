class AppMarketing::GeoFencedPushsController < AppMarketing::BaseController
  check_authorization
  before_action :set_geo_messages
  before_action :set_geo_message, only: :destroy
  before_action :set_new_geo_message, except: :destroy

  helper_method :build_new_geo_message

  def index
    authorize! :show, :push_notifications
  end

  def create
    authorize! :use, :push_notifications
    respond_to do |format|
      if @new_geo_message.update(geo_message_params)
        t_flash_success
        format.html { redirect_to action: :index }
      else
        t_flash_error
        format.html { render 'index' }
      end
      format.js
    end
  end

  def destroy
    authorize! :use, :push_notifications
    @geo_message.destroy!
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end

  private

  def set_geo_messages
    @geo_messages = current_application.geo_messages
  end

  def set_geo_message
    @geo_message = @geo_messages.find(params[:id])
  end

  def set_new_geo_message
    @new_geo_message = build_new_geo_message
  end

  def build_new_geo_message
    @geo_messages.build
  end

  def geo_message_params
    params.require(:geo_message).permit(:message, :start_time, :end_time, :one_time_notification,
      :fire_on, :latitude, :longitude)
  end
end
