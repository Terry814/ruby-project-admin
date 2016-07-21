class AppSettings::SocialStreamsController < AppSettings::BaseController
  authorize_resource class: SocialStream

  before_action :set_social_streams
  before_action :set_social_stream, only: [:update, :destroy, :new_account, :add_account]
  before_action :set_source_account, only: :destroy_account
  before_action :set_new_social_stream, except: [:destroy, :destroy_account]
  before_action :set_new_source_account, only: [:new_account, :add_account]

  helper_method :build_social_stream

  def create
    respond_to do |format|
      if @new_social_stream.update(social_stream_params)
        t_flash_success
        format.html { redirect_to action: :index }
      else
        t_flash_error
        format.html { render :index }
      end
      format.js
    end
  end

  def update
    respond_to do |format|
      if @social_stream.update(social_stream_params)
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
    @social_stream.destroy!
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end

  def add_account
    respond_to do |format|
      if @new_source_account.update(social_source_account_params)
        t_flash_success
        format.html { redirect_to action: :index }
      else
        t_flash_error
        format.html { render :index }
      end
      format.js
    end
  end

  def destroy_account
    @social_account.destroy!
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js
    end
  end

  private

  def set_social_streams
    @social_streams = SocialStream.of_app current_application
  end

  def set_social_stream
    id = params[:stream_id] || params[:id]
    @social_stream = @social_streams.find(id)
  end

  def set_source_account
    @social_streams.each do |stream|
      @social_account = stream.social_source_accounts.find_by(id: params[:id]) and break
    end
  end

  def build_social_stream
    SocialStream.build_with_application_info current_application
  end

  def set_new_social_stream
    @new_social_stream = build_social_stream
  end

  def set_new_source_account
    @new_source_account = @social_stream.social_source_accounts.build
  end

  def social_stream_params
    params.require(:social_stream).permit(menu_item_attributes: [:display_name, :enabled, :id])
  end

  def social_source_account_params
    params.require(:social_source_account).permit(:username, :list_name, :hashtag, :service)
  end
end