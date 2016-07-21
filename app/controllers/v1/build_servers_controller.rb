class V1::BuildServersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_server_token, only: :instant_ready

  def instant_ready
    app = ApplicationInfo.find_by!(app_id_suffix: params[:app_id])
    user = app.user

    download_page_url = v1_instant_download_page_url(bundle_suffix: app.app_id_suffix)
    UserMailer.instant_download_link_email(app.user, download_page_url).deliver

    user.send_reset_password_instructions unless user.took_ownership?

    head :ok
  end

  private

  def check_server_token
    head :forbidden unless params[:server_token] == ENV['INSTANT_BUILD_SERVER_TOKEN']
  end
end