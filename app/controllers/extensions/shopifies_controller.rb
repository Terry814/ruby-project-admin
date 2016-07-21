class Extensions::ShopifiesController < Extensions::BaseController
  authorize_resource class: Shopify

  before_action :set_shopify

  def update
    respond_to do |format|
      if @shopify.update(shopify_params)
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

  def set_shopify
    @shopify = Shopify.first_of_app_or_initialize current_application
    @shopify.menu_item.display_name ||= "E-Commerce"
  end

  def shopify_params
    params.require(:shopify).permit(:url, menu_item_attributes: [:display_name, :id, :enabled])
  end
end