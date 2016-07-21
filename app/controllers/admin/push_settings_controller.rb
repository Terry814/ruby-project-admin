class Admin::PushSettingsController < Admin::BaseController
  before_action :authenticate_user!
  before_action :authorize_admin_managment

  before_action :set_applications, only: :index

  def update
    @app = ApplicationInfo.find params[:app_id]

    file = params.require(:certificate).require(:file)
    if file.content_type != 'application/x-pkcs12'
      flash[:error] = t('.errors.not_p12_file')
      redirect_to :back and return
    end

    contents = file.read

    pkcs12 = OpenSSL::PKCS12.new contents, ''
    p12_app_id = pkcs12.certificate.subject.to_a.select { |a| a.first == "UID" } .first[1]
    if p12_app_id != "com.appease.#{@app.app_id_suffix}"
      flash[:error] = t('.errors.wrong_app_id')
      redirect_to :back and return
    end

    unless pkcs12.certificate.not_after.future?
      flash[:error] = t('.errors.expired_cert')
      redirect_to :back and return
    end

    body = {
      name: @app.app_id_suffix,
      apns_env: 'production',
      apns_p12: Base64.encode64(contents),
      apns_p12_password: ""
    }

    res = if @app.onesignal_app_id.present?
      OneSignal::HttpClient.put("/apps/#{@app.onesignal_app_id}", body: body)
    else
      OneSignal::HttpClient.post("/apps", body: body)
    end

    if res.ok? &&
      @app.update(onesignal_app_id: res['id'], onesignal_app_key: res['basic_auth_key'])
      t_flash_success
    else
      flash[:error] = res['errors'].try(:first) || t('.failure')
    end
    redirect_to :back
end

  private

  def set_applications
    @apps = ApplicationInfo.includes(:user).order(:created_at).page(params[:page])
  end

  def authorize_admin_managment
    authorize! :manage, :admin_page
  end
end
