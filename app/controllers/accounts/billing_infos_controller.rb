class Accounts::BillingInfosController < Accounts::BaseController
  before_action :set_billing_info
  after_action :report_event, only: :update

  def show
    if params[:redirect_to].present?
      @custom_url = accounts_billing_info_path(redirect_to: params[:redirect_to])
    end
  end

  def update
    stripe_token = params["stripeToken"]
    stripe_email = params["stripeEmail"]

    customer = if @billing_info.stripe_customer_id.blank?
      Stripe::Customer.create(
        description: "#{current_user.full_name}",
        card: stripe_token,
        email: current_user.email,
        metadata: {
          user_id: current_user.id
        }
      )
    else
      customer = Stripe::Customer.retrieve(@billing_info.stripe_customer_id)
      customer.card = stripe_token
      customer.save
    end

    attrs = {
      email: stripe_email,
      stripe_customer_id: customer.id,
      stripe_card_token: stripe_token,
      card_brand: customer.cards.data.first.brand,
      card_last_four: customer.cards.data.first.last4
    }

    had_card_info = current_user.has_card_info?
    @billing_info.update! attrs

    if params[:redirect_to].present?
      dest = params[:redirect_to]
      if params[:with_format] == 'true'
        redirect_to dest, format: request.format.symbol
      else
        redirect_to_page dest
      end
    else
      t_flash_success
      respond_to do |format|
        format.html { redirect_to action: :show }
        format.js
      end
    end
  end

  def add_coupon
    coupon_code = params[:coupon][:code]
    if coupon_code.blank?
      t_flash_error
      @error = t('.errors.coupon_code_blank')
      respond_to do |format|
        format.html { render 'show' }
        format.js
      end and return
    end

    begin
      customer = if @billing_info.stripe_customer_id.blank?
        Stripe::Customer.create(
          description: "#{current_user.full_name}",
          coupon: coupon_code,
          email: current_user.email,
          metadata: {
            user_id: current_user.id
          }
        )
      else
        customer = Stripe::Customer.retrieve(@billing_info.stripe_customer_id)
        customer.coupon = coupon_code
        customer.save
      end
    rescue Stripe::InvalidRequestError => e
      t_flash_error
      @error = e.message
      respond_to do |format|
        format.html { render 'show' }
        format.js
      end and return
    end

    respond_to do |format|
      if @billing_info.update(stripe_customer_id: customer.id)
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

  def set_billing_info
    @billing_info = current_user.billing_info || current_user.build_billing_info
  end

  def report_event
    name = if @billing_info.created_at == @billing_info.updated_at
             'added-billing-info'
           else
             'updated-billing-info'
           end

    create_intercom_event(
      event_name: name,
      created_at: Time.now.to_i,
      user_id: current_user.id,
      metadata: {
        stripe_customer: current_user.billing_info.stripe_customer_id
      }
    )
  end
end
