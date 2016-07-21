class Extensions::ContactsController < Extensions::BaseController
  authorize_resource class: ContactUsInfo

  before_action :set_contact_us_info
  before_action :ensure_contact_us_info_exists, only: :add_location
  before_action :set_location, only: :destroy_location
  before_action :set_new_location, except: [:destroy_location, :update]

  helper_method :build_new_location

  def update
    respond_to do |format|
      if @contact_us_info.update(contact_us_info_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { set_new_location and render :show }
      end
      format.js
    end
  end

  def add_location
    authorize! :create, @new_location
    respond_to do |format|
      if @new_location.update(location_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
  end

  def destroy_location
    @location.destroy!
    respond_to do |format|
      format.html { redirect_to action: :show }
      format.js
    end
  end

  private

  def set_contact_us_info
    @contact_us_info = ContactUsInfo.first_of_app_or_initialize current_application
  end

  def ensure_contact_us_info_exists
    if @contact_us_info.new_record?
      @contact_us_info.menu_item.enabled = true
      @contact_us_info.menu_item.display_name = "Contact Us"
      @contact_us_info.save
    end
  end

  def set_location
    @location = @contact_us_info.contact_locations.find(params[:id])
  end

  def set_new_location
    @new_location = build_new_location
  end

  def build_new_location
    @contact_us_info.contact_locations.build
  end

  def contact_us_info_params
    params.require(:contact_us_info).permit(menu_item_attributes: [:display_name, :id, :enabled])
  end

  def location_params
    params.require(:contact_location).permit(:name, :street_line_one, :city, :state, :postal_code, :email, :phone_number, :image)
  end
end