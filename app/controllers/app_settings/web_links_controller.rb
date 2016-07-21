class AppSettings::WebLinksController < AppSettings::BaseController
  authorize_resource class: WebLink

  before_action :set_web_links
  before_action :set_new_link, except: :destroy
  before_action :set_web_link, only: :destroy

  helper_method :build_new_web_link

  def create
    respond_to do |format|
      if @new_web_link.update(web_link_params)
        t_flash_success
        format.html { redirect_to action: :index }
      else
        t_flash_error
        format.html { render :index }
      end
      format.js
    end
  end

  def destroy
    @web_link.destroy!
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end

  private

  def set_new_link
    @new_web_link = build_new_web_link
  end

  def build_new_web_link
    WebLink.build_with_application_info current_application
  end

  def set_web_link
    @web_link = @web_links.find(params[:id])
  end

  def set_web_links
    @web_links = WebLink.of_app current_application
  end

  def web_link_params
    params.require(:web_link).permit(:url, :show_navigation, menu_item_attributes: [:display_name])
  end
end