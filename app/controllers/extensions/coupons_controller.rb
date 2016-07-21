class Extensions::CouponsController < Extensions::BaseController
  authorize_resource class: Coupons

  before_action :set_coupons
  before_action :ensure_coupons_exists, only: :add_coupon_info
  before_action :set_coupon_info, only: [:destroy_coupon_info]
  before_action :set_new_coupon_info, except: [:destroy_coupon_info, :update]

  helper_method :build_new_coupon_info

  def update
    respond_to do |format|
      if @coupons.update(coupons_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { set_new_coupon_info and render :show }
      end
      format.js
    end
  end

  def add_coupon_info
    respond_to do |format|
      if @new_coupon_info.update(coupon_info_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
  end

  def destroy_coupon_info
    @coupon_info.destroy!
    respond_to do |format|
      format.html { redirect_to action: :show }
      format.js
    end
  end

  private

  def set_coupons
    @coupons = Coupons.first_of_app_or_initialize current_application
  end

  def ensure_coupons_exists
    if @coupons.new_record?
      @coupons.menu_item.enabled = true
      @coupons.menu_item.display_name = "Coupons"
      @coupons.save
    end

  end

  def set_coupon_info
    @coupon_info = @coupons.coupon_infos.find(params[:id])
  end

  def set_new_coupon_info
    @new_coupon_info = build_new_coupon_info
  end

  def build_new_coupon_info
    @coupons.coupon_infos.build
  end

  def coupons_params
    params.require(:coupons).permit(menu_item_attributes: [:display_name, :enabled, :id])
  end

  def coupon_info_params
    params.require(:coupon_info).permit(:title, :description, :expiry_date, :image)
  end
end