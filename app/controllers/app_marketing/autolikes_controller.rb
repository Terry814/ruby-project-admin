class AppMarketing::AutolikesController < AppMarketing::BaseController
  before_action :set_autolike
  check_authorization

  def show
    authorize! :show, :autolikes
    @twitter_enabled = current_user.identities.where(provider: Identity.providers[:twitter]).any?
  end

  def update
    authorize! :use, :autolikes

    params = autolike_params
    params["hashtags"].delete_if(&:blank?)

    respond_to do |format|
      if @autolike.update(params)
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

  def set_autolike
    @autolike = Autolike.find_or_initialize_by(application_info: current_application)
  end

  def autolike_params
    params.require(:autolike).permit(:enabled, :hashtags => [])
  end
end
