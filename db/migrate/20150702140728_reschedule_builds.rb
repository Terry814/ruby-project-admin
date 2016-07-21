class RescheduleBuilds < ActiveRecord::Migration
  def up
    ids = ApplicationInfo.pluck(:app_id_suffix)
    ids.reverse_each { |id| $instant_build_queue.send_message(id) }
  end

  def down
    
  end
end
