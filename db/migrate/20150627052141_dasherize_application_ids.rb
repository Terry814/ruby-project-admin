class DasherizeApplicationIds < ActiveRecord::Migration
  def up
    ids = []
    ApplicationInfo.find_each do |app|
      new_app_id = app.app_id_suffix.dasherize
      app.update(app_id_suffix: new_app_id)
      ids << new_app_id
    end
    ids.reverse_each { |id| $instant_build_queue.send_message(id) }
  end

  def down
  end
end
