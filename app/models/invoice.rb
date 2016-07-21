# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  date            :date
#  description     :string(255)
#  total           :float
#  billing_info_id :integer
#  stripe_id       :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#
# Indexes
#
#  index_invoices_on_billing_info_id  (billing_info_id)
#

class Invoice < ActiveRecord::Base
  belongs_to :billing_info
  has_many :invoice_lines, dependent: :destroy
end
