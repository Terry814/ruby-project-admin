class Ability
  include CanCan::Ability

  EXTENSIONS = [
                ContactUsInfo, 
                Coupons, 
                CustomerFeedback, 
                PdfFileItem, 
                ProductMenu, 
                Shopify, 
                OpenTable
               ]
  FREE_FEATURES = [
                   SocialStream, 
                   WebLink
                  ]
  APP_MARKETING = [
                   :push_notifications, :autolikes, :autoposts
                  ]
  def initialize(user)
    # all users' abilities
    can :read, EXTENSIONS
    can :read, APP_MARKETING
    can :manage, FREE_FEATURES
    can :manage, :admin_page if user.admin?

    # package specific abilities
    case user.current_package
    when 'starter'
      can :create, ContactLocation do |loc|
        loc.contact_us_info.contact_locations.count < 1
      end
    when 'marketer'
      can :manage, EXTENSIONS
      can :manage, APP_MARKETING
      can :create, ContactLocation do |loc|
        loc.contact_us_info.contact_locations.count < 1
      end
    when 'enterprise'
      can :manage, EXTENSIONS
      can :manage, APP_MARKETING
      can :create, ContactLocation
    end
  end
end
