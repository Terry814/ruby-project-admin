class Extensions::ProductMenusController < Extensions::BaseController
  authorize_resource class: ProductMenu

  before_action :set_product_menu
  before_action :ensure_product_menu_exists, only: :create_category
  before_action :set_category, only: [:edit_category, :update_category, :destroy_category]
  before_action :set_menu_item, only: [:edit_menu_item, :update_menu_item, :destroy_menu_item]
  before_action :set_new_items, only: [:show, :create_category, :create_menu_item, :destroy_category, :update_category]
  before_action :set_new_category, only: [:edit_menu_item, :update_menu_item]
  before_action :set_new_menu_item, only: [:edit_category, :update_menu_item, :destroy_menu_item]

  helper_method :build_new_category, :build_new_menu_item

  def update
    respond_to do |format|
      if @product_menu.update(product_menu_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        # calling by hand so it doesn't prevent validations
        format.html { set_new_items and render :show }
      end
      format.js
    end
  end

  def create_category
    respond_to do |format|
      if @new_category.update(category_params)
        @new_category.insert_at(category_position_param)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
  end

  def edit_category
    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  def update_category
    respond_to do |format|
      if @category.update(category_params)
        @category.insert_at(category_position_param)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
    end

  def destroy_category
    @category.destroy!
    respond_to do |format|
      format.html { redirect_to action: :show }
      format.js
    end
  end

  def create_menu_item
    respond_to do |format|
      if @new_menu_item.update(menu_item_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
    format.js
    end
  end

  def edit_menu_item
    respond_to do |format|
      format.html { render :show }
      format.js
    end
  end

  def update_menu_item
    respond_to do |format|
      if @menu_item.update(menu_item_params)
        t_flash_success
        format.html { redirect_to action: :show }
      else
        t_flash_error
        format.html { render :show }
      end
      format.js
    end
  end

  def destroy_menu_item
    @menu_item.destroy!
    respond_to do |format|
      format.html { redirect_to action: :show }
      format.js
    end
  end

  private

  def set_product_menu
    @product_menu = ProductMenu.first_of_app_or_initialize current_application
  end

  def ensure_product_menu_exists
    if @product_menu.new_record?
      @product_menu.menu_item.enabled = true
      @product_menu.menu_item.display_name = "Product Menu"
      @product_menu.save
    end
  end

  def set_new_items
    set_new_category
    set_new_menu_item
  end

  def set_new_category
    @new_category = build_new_category
  end

  def build_new_category
    @product_menu.categories.build
  end

  def set_new_menu_item
    @new_menu_item = build_new_menu_item
  end

  def build_new_menu_item
    @product_menu.menu_items.build
  end

  def set_category
    @category = @product_menu.categories.find(params[:id])
  end

  def set_menu_item
    @menu_item = @product_menu.menu_items.find(params[:id])
  end

  def product_menu_params
    params.require(:product_menu).permit(menu_item_attributes: [:display_name, :enabled, :id])
  end

  def category_params
    params.require(:product_menu_category).permit(:name)
  end

  def menu_item_params
    params.require(:product_menu_item).permit(:name, :price, :description, :product_menu_category_id, :image)
  end

  def category_position_param
    position_param(:product_menu_category).to_i
  end

  def position_param model_key
    params.require(model_key)[:position]
  end
end