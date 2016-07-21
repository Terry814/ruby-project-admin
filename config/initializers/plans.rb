# enum current_package: { starter: 0, marketer: 1, enterprise: 2 }
# You can add more plans here, but to make them work you'll need to add them on stripe and set on user.rb, and define abilites on ability.rb. You better don't touch plan names and contact developer when adding more plans.

first_tear_features = [
                       'iOS & Android Apps',
                       'Phones & Tablets',
                       'Professional Support',
                       'App Store Management',
                       'Unlimited Downloads & Usage',
                      ]

second_tear_features = first_tear_features + [
                                              'App Marketing Features',
                                             ]
third_tear_features = second_tear_features + [
                                              'Your App Account + Paid Apps',
                                             ]

plans = {
  'starter' => {
    name: 'Starter',
    price: 19,
    features: first_tear_features,
    description: 'Choose this plan if you have a single location and do not wish to use geo fenced push notifications.'
    },
  'marketer' => {
    name: 'Marketer',
    price: 49,
    features: second_tear_features,
    description: 'Choose this plan if you have a single location and wish to use geo fenced push notifications.'
    },
  'enterprise' => {
    name: 'Enterprise',
    price: 99,
    features: third_tear_features,
    description: 'Choose this plan if you have multiple locations and wish to use geo fenced push notifications.'
    }
  }


plans.each do |name, info|
  [:name, :price, :description, :features].each do |key|
    raise "missing key #{key}, check config/initializers/plans.rb." unless info.has_key? key
  end
end

os_plans = {}
plans.each { |name, info| os_plans[name] = OpenStruct.new(info) }

Rails.configuration.appease_plans = os_plans
