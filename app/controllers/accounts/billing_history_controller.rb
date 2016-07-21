class Accounts::BillingHistoryController < Accounts::BaseController
  before_action :set_invoices, only: :index
  before_action :set_invoice_details, only: [:invoice, :invoice_print]

  def invoice_print
    @for_print = true
    render 'invoice', layout: 'print'
  end

  private

  def set_invoices
    @invoices = invoices
  end

  def set_invoice_details
    @invoice = invoices.find(params[:id])
    @sender_details = Rails.configuration.invoice_sender_details
  end

  def invoices
    return Invoice.none if current_user.billing_info.blank?
    current_user.billing_info.invoices
  end
end