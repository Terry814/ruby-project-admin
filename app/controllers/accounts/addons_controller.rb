class Accounts::AddonsController < Accounts::BaseController
  before_action :set_addons
  before_action :ensure_billing_info!, only: :place_order

  def place_order
    addon_id = params[:id]
    addon = @addons.find { |a| a.id.eql? addon_id }

    begin
      charge = Stripe::Charge.create(
        amount: (addon.price * 100).to_i,
        currency: "usd",
        customer: current_user.billing_info.stripe_customer_id,
        description: "Charge for addon: #{addon.name}",
        statement_description: addon.name.truncate(15, omission: "")
      )
    rescue Stripe::CardError => e
      body = e.json_body
      err  = body[:error]
      @error = err[:message]
      render 'show' and return
    rescue Stripe::APIConnectionError => e
      @error = "We couldn't process your purchaes, please try again later"
      render 'show' and return
    else
      AdminMailer.addon_purchase_email(current_user, addon, charge).deliver
    end

    redirect_to action: :show
  end

  private

  def set_addons
    @addons = Rails.configuration.appease_addons
  end
end