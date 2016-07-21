class QueueBuildJob
  include SuckerPunch::Job
  
  def perform(app_id)
    return unless Rails.env.production?
    $instant_build_queue.send_message(app_id)
  end

  def later(sec, app_id)
    after(sec) { perform(app_id) }
  end
end