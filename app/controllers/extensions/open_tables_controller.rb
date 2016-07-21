class Extensions::OpenTablesController < Extensions::BaseController
  authorize_resource class: OpenTable

  before_action :set_open_table

  def update
    respond_to do |format|
      if @opentable.update(open_table_params)
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

  def set_open_table
    @opentable = OpenTable.first_of_app_or_initialize current_application
    @opentable.menu_item.display_name ||= "OpenTable"
  end

  def open_table_params
    params.require(:open_table).permit(:url, menu_item_attributes: [:display_name, :id, :enabled])
  end
end