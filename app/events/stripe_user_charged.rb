class StripeUserCharged
  def call(event)
    charge = event.data.object
    # invoices handled seperately
    return if charge.invoice.present?

    billing_info = BillingInfo.find_by!(stripe_customer_id: charge.customer)
    invoice = billing_info.invoices.build(
      date: Time.at(charge.created).to_date,
      description: charge.description,
      total: charge.amount.to_f / 100,
      stripe_id: charge.id
    )
    invoice.invoice_lines.build(
      description: charge.description,
      amount: invoice.total
    )
    invoice.save
  end
end