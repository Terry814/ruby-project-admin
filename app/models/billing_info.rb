# == Schema Information
#
# Table name: billing_infos
#
#  id                        :integer          not null, primary key
#  card_last_four            :string(255)
#  stripe_card_token         :string(255)
#  stripe_customer_id        :string(255)
#  stripe_subscription_id    :string(255)
#  user_id                   :integer
#  created_at                :datetime
#  updated_at                :datetime
#  email                     :string(255)
#  card_brand                :string(255)
#  subscription_cancelled_at :datetime
#
# Indexes
#
#  index_billing_infos_on_user_id  (user_id)
#

class BillingInfo < ActiveRecord::Base
  belongs_to :user
  has_many :invoices, dependent: :destroy

  validates_presence_of :stripe_customer_id

  def has_card_info?
    card_last_four.present? || stripe_card_token.present?
  end

  def subscribed?
    stripe_subscription_id.present?
  end

  def cancel_subscription
    return if !subscribed?
    begin
      customer = Stripe::Customer.retrieve(stripe_customer_id)
      customer.subscriptions.retrieve(stripe_subscription_id).delete
    rescue => e
      AdminMailer.exception_email(e, 'User subscription cancellation', user).deliver
    else
      update(stripe_subscription_id: nil, subscription_cancelled_at: DateTime.current)
    end
  end
end
