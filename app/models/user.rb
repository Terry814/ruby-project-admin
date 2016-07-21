# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  company_name             :string(255)
#  full_name                :string(255)
#  email                    :string(255)      default(""), not null
#  encrypted_password       :string(255)      default(""), not null
#  reset_password_token     :string(255)
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string(255)
#  last_sign_in_ip          :string(255)
#  confirmation_token       :string(255)
#  confirmed_at             :datetime
#  confirmation_sent_at     :datetime
#  unconfirmed_email        :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  subscribed_to_emails     :boolean          default(TRUE)
#  current_package          :integer          default(0)
#  sign_up_method           :integer          default(0)
#  phone_number             :string(255)
#  last_changed_password_at :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  paginates_per 50

  attr_accessor :terms
  has_one :application_info, dependent: :destroy
  has_one :billing_info, dependent: :destroy

  has_many :identities, dependent: :destroy

  after_create :create_app_info_with_id
  before_create :set_default_package

  delegate :has_card_info?, :subscribed?, :cancel_subscription, to: :billing_info, allow_nil: true
  delegate :published?, :last_published_at, to: :application_info

  enum current_package: { 'starter': 0, 'marketer': 1, 'enterprise': 2 }
  enum sign_up_method: { plain: 0, wizard: 1, admin: 2 }

  phony_normalize :phone_number, default_country_code: 'US'

  validates_presence_of :company_name, :full_name, on: [:create, :update]
  validates_acceptance_of :terms, allow_nil: false, message: "not accepted", on: :create
  validates_plausible_phone :phone_number

  scope :customers, -> { joins(:billing_info).where.not(billing_infos: {stripe_subscription_id: nil}) }
  scope :prospects, -> { joins(:application_info).where(application_infos: {json_fetched_by_preview: true}) }
  scope :triers, -> { joins(:application_info).where(application_infos: {last_published_at: nil}).where(application_infos: {json_fetched_by_preview: false}) }
  scope :canceled, -> { joins(:billing_info).where.not(billing_infos: {subscription_cancelled_at: nil}) }
  scope :unclaimed, -> { where(sign_up_method: User.sign_up_methods[:admin], last_changed_password_at: nil) }

  def self.plan_name_for package_name
    if Rails.configuration.appease_plans[package_name].present?
      Rails.configuration.appease_plans[package_name].name
    else
      package_name.humanize
    end
  end

  def plan_name
    User.plan_name_for current_package
  end

  def admin?
    admin_emails = ENV['ADMINS'].split(';')
    admin_emails.include? email
  end

  def tasks
    Rails.configuration.initial_tasks
  end

  def ready_to_publish?
    asi = application_info.app_stores_info
    asi.valid_for_itunes? && asi.valid_for_play_market? && has_card_info?
  end

  def needs_publish?
    last_published = application_info.last_published_at
    return true if last_published.nil?
    last_icon_update = application_info.app_stores_info.app_icon_updated_at
    last_published.to_i < last_icon_update.to_i
  end

  def took_ownership?
    sign_up_method == 'admin' ? last_changed_password_at.present? : true
  end

  private

  def set_default_package
    self.current_package = User.current_packages[:enterprise]
  end

  def create_app_info_with_id
    ApplicationInfo.no_touching do
      create_application_info(app_id_suffix: user_app_id_suffix)
    end
  end

  def user_app_id_suffix
    "#{id}-#{company_name.dasherize.parameterize}"
  end
end
