class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include HomePathHelper
  include ExceptionResponders
  include BillingFlowRedirects
  include AjaxFlash
  include I18nFlash
  include RealUserHelper
  include IntercomHelper

  helper_method :current_application

  helper_method :switched_user?

  def current_application
    current_user.application_info
  end

  def switched_user?
    su_provider = SwitchUser::Provider.init(self)
    su_provider.original_user.present?
  end

  protected

  def redirect_to_page path
    respond_to do |format|
      format.js { render js: "$.pjax({url: '#{path}', container: '[data-pjax-container]', timeout: 5000});" }
      format.html { redirect_to path }
    end
  end

  def pjax_layout
    'application_container'
  end

  def after_sign_in_path_for(resource)
    home_path_with_company_name
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
