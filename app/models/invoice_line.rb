# == Schema Information
#
# Table name: invoice_lines
#
#  id          :integer          not null, primary key
#  description :string(255)
#  amount      :float
#  invoice_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  index_invoice_lines_on_invoice_id  (invoice_id)
#

class InvoiceLine < ActiveRecord::Base
  belongs_to :invoice
end
