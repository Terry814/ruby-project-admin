class NotifyClientsJob
  include SuckerPunch::Job

  def perform(app_id, app_key, id)
    SuckerPunch.logger.debug "Sending to #{id}"
    push = OneSignal::PushNotification.new app_id, app_key, id
    push.content_available = true
    push.data = {'content-type' => 'config:updated'}
    push.send
  end
end
