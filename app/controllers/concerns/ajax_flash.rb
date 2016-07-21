module AjaxFlash
  extend ActiveSupport::Concern
  included do
    after_action :set_flash_to_header, if: :ajax_request?
  end

  protected
  
  def ajax_request?
    request.xhr? && !pjax_request?
  end

  def set_flash_to_header
    response.headers['X-Flash-Messages'] = flash.to_h.to_json
    flash.discard
  end
end