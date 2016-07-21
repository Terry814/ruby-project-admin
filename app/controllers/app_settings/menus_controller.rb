class AppSettings::MenusController < AppSettings::BaseController
  before_action :set_application_info
  before_action :set_menu_items, except: :update

  def update
    ordered_ids_array = params[:menu_item]
    app_home_id = params.require(:application_info).fetch(:app_home)
    has_changes = false
    ApplicationInfo.no_touching do
      @app_info.menu_items.enabled.each do |item|
        position = ordered_ids_array.find_index(item.id.to_s)
        if !!position && position != item.position
          item.insert_at(position)
          has_changes = true
        end
        if item.app_home != (item.id.to_s == app_home_id)
          item.update(app_home: item.id.to_s == app_home_id)
          has_changes = true
        end
      end
    end
    unless @app_info.updated_menu
      @app_info.update(updated_menu: true)
      has_changes = true
    end
    @app_info.touch if has_changes
    t_flash_success true
    respond_to do |format|
      format.html { set_menu_items and render :show }
      format.js { head :ok }
    end
  end

  private

  def set_application_info
    @app_info = current_application
  end

  def set_menu_items
    @menu_items = @app_info.menu_items.enabled
    @app_info.app_home = @menu_items.find_by(app_home: true) || @menu_items.first
  end
end