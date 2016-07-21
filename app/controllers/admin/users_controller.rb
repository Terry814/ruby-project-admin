class Admin::UsersController < Admin::BaseController
  before_action :authenticate_user!
  before_action :authorize_admin_managment
  before_action :set_user, only: [:destroy_subscription, :become, :destroy_user]

  def customers
    @customer = true
    show_with_scope_per_page :customers
  end

  def prospects
    show_with_scope_per_page :prospects
  end

  def triers
    show_with_scope_per_page :triers
  end

  def canceled
    show_with_scope_per_page :canceled
  end

  def unclaimed
    show_with_scope_per_page :unclaimed
  end

  def update_ad_frequency
    ad_frequency = params[:ad_frequency]
    app = ApplicationInfo.find params[:app_id]
    respond_to do |format|
      if app.update(ad_frequency: ad_frequency)
        t_flash_success
        format.js { head :ok }
      else
        t_flash_error
        format.js { head :internal_server_error }
      end
    end
  end

  def destroy_subscription
    @user.cancel_subscription
    redirect_to :back
  end

  def destroy_user
    ApplicationInfo.no_touching do
      @user.destroy
    end
    redirect_to :back
  end

  def become
    su_provider = SwitchUser::Provider.init(self)
    su_provider.remember_current_user true
    redirect_to switch_user_path(scope_identifier: "user_#{@user.id}")
  end

  private

  def show_with_scope_per_page scope
    users_scoped = case scope
                   when :customers then User.customers
                   when :prospects then User.prospects
                   when :triers then User.triers
                   when :canceled then User.canceled
                   when :unclaimed then User.unclaimed
                   else User.all
                   end 
    @filtered_count = users_scoped.count
    @users = users_scoped.order(:created_at).page(params[:page])
    render 'show'
  end

  def authorize_admin_managment
    authorize! :manage, :admin_page
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
