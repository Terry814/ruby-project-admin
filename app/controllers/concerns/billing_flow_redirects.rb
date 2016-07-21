module BillingFlowRedirects

  protected
  
  def ensure_billing_info!
    if current_user.billing_info.blank?
      flash[:notice] = "Please provide payment info before you continue"
      dest = request.get? ? request.url : request.env["HTTP_REFERER"]
      redirect_to_page accounts_billing_info_url(redirect_to: dest)
    end
  end
end