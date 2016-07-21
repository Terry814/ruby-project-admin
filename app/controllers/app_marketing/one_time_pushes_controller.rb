class AppMarketing::OneTimePushesController < AppMarketing::BaseController
  check_authorization

  def show
    authorize! :show, :push_notifications
  end

  def create
    authorize! :use, :push_notifications
    message = params[:push_notification][:message]

    if message.blank?
      @error = t('.errors.message_blank')
      respond_to do |format|
        format.html { render 'show' }
        format.js
      end and return
    end

    os_id = current_application.onesignal_app_id
    os_key = current_application.onesignal_app_key

    @error = t('.errors.no_app_id') if os_id.blank? || os_key.blank?

    parse_res = OneSignal::PushNotification.new(
      os_id, os_key, current_application.app_id_suffix, message).send
    respond_to do |format|
      if parse_res.ok?
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        @error = parse_res["errors"].try(:first)
        format.html { render 'show' }
      end
      format.js
    end
  end
end
