class StripeInvoicePaymentSucceeded
  def call(event)
    invoice = event.data.object
    
    billing_info = BillingInfo.find_by!(stripe_customer_id: invoice.customer)

    period_start = Time.at(invoice.period_start).to_date.to_formatted_s(:short)
    period_end = Time.at(invoice.period_end).to_date.to_formatted_s(:short)

    i = billing_info.invoices.build(
      date: Time.at(invoice.date).to_date,
      description: "Invoice for period: #{period_start} - #{period_end}",
      total: invoice.total.to_f / 100,
      stripe_id: invoice.id
    )
    invoice.lines.data.each do |invoice_line|
      i.invoice_lines.build(
        description: invoice_line.description,
        amount: invoice_line.amount.to_f / 100
      )
    end

    i.save
  end
end