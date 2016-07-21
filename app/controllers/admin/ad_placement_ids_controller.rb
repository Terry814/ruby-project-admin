class Admin::AdPlacementIdsController < Admin::BaseController
  before_action :authenticate_user!
  before_action :authorize_admin_managment

  before_action :set_placement_ids
  before_action :set_new_placement_id, except: :destroy
  before_action :set_placement_id, only: :destroy

  helper_method :build_new_placement_id

  def create
    respond_to do |format|
      if @new_placement_id.update(placement_id_params)
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
    @placement_id.destroy!
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end
  
  private

  def authorize_admin_managment
    authorize! :manage, :admin_page
  end

  def set_new_placement_id
    @new_placement_id = build_new_placement_id
  end

  def build_new_placement_id
    AdPlacementId.new
  end

  def set_placement_id
    @placement_id = @placement_ids.find(params[:id])
  end

  def set_placement_ids
    @placement_ids = AdPlacementId.all
  end

  def placement_id_params
    params.require(:ad_placement_id).permit(:placement_id, :platform)
  end
end