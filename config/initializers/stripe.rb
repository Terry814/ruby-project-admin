sk_key_key = Rails.env.production? ? "STRIPE_LIVE_SK" : "STRIPE_TEST_SK"
pk_key_key = Rails.env.production? ? "STRIPE_LIVE_PK" : "STRIPE_TEST_PK"
Rails.configuration.stripe = {
  publishable_key: ENV[pk_key_key],
  secret_key:      ENV[sk_key_key]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded', StripeUserCharged.new
  events.subscribe 'invoice.payment_succeeded', StripeInvoicePaymentSucceeded.new
end
StripeEvent.event_retriever = lambda do |params|
  return nil unless StripeEvent.listening? params[:type]
  Stripe::Event.retrieve(params[:id])
end