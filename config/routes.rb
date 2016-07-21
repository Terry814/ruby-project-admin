# require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, path: 'users', skip: [:registrations, :sessions], controllers: {
      registrations: 'users/registrations',
      passwords: 'users/passwords',
    }
  devise_scope :user do
     # devise/registrations
     get 'sign-up' => 'users/registrations#new', :as => :new_user_registration
     post 'users' => 'users/registrations#create', :as => :user_registration
     put 'users' => 'users/registrations#update'
     delete 'users' => 'users/registrations#destroy'
     get 'accounts/settings' => 'users/registrations#edit', :as => :edit_user_registration
     get 'users/cancel' => 'users/registrations#cancel', :as => :cancel_user_registration

    # devise/sessions
    get 'sign-in' => 'users/sessions#new', :as => :new_user_session
    post 'sign-in' => 'users/sessions#create', :as => :user_session
    delete 'sign-out' => 'users/sessions#destroy', :as => :destroy_user_session
  end

  # authenticate :user, lambda { |u| u.admin? } do
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  root to: 'home#index'

  get ':company_name/home' => 'home#index', as: :home
  mount StripeEvent::Engine => '/stripe'

  get 'oauth/facebook' => 'app_settings/connections#fb_callback'
  get 'oauth/instagram' => 'app_settings/connections#ig_callback'
  get 'oauth/twitter' => 'app_settings/connections#tw_callback'

  # ADMIN PAGE
  namespace :admin do
    scope path: 'users', as: 'users' do
      get 'customers/' => 'users#customers'
      get 'prospects/' => 'users#prospects'
      get 'triers/' => 'users#triers'
      get 'canceled/' => 'users#canceled'
      get 'unclaimed/' => 'users#unclaimed'
      delete '/:user_id' => 'users#destroy_user', as: :destroy_user
      put ':app_id/ad_frequency' => 'users#update_ad_frequency'
    end
    get 'become' => 'users#become', as: :become
    delete 'subscription/:user_id' => 'users#destroy_subscription', as: :user_subscription

    resources :ad_placement_ids, only: [:index, :create, :destroy], path: 'ads'

    get 'push-settings' => 'push_settings#index', as: :push_settings
    put 'push-settings/:app_id' => 'push_settings#update', as: :push_setting
  end

  namespace :v1 do
    get ':bundle_suffix/download' => 'app_configuration#download_page', as: :instant_download_page

    scope path: 'wizard' do
      post 'instant/ready' => 'build_servers#instant_ready'
    end

    defaults format: 'json' do
      get 'com.appease.:bundle_suffix/config' => 'app_configuration#config_json', as: :app_configuration
      get 'info' => 'app_configuration#info'
      get 'location/:id/messages' => 'app_configuration#location_messages'

      get 'ads/ios' => 'app_configuration#ios_ads'
      get 'ads/android' => 'app_configuration#android_ads'
    end
  end

  namespace :app_marketing, path: 'app-marketing' do
    # AUTOPOST
    resource :autopost, only: [:show, :update]

    # AUTOPUSH
    get 'autopush' => 'autopushs#show'

    # AUTOLIKE
    resource :autolike, only: [:show, :update]

    # ONE TIME PUSH
    resource :one_time_push, only: [:show, :create], path: 'one-time-push'

    # GEO FENCED PUSH
    resources :geo_fenced_pushs, only: [:index, :create, :destroy], path: 'geo-fenced-push'
  end

  namespace :app_settings, path: 'app-settings' do
    # MENU
    resource :menu, only: [:show, :update]

    # MENU COVER IMAGE
    resource :menu_cover_image, only: [:show, :create, :update, :destroy], path: 'cover-image'

    # WEB LINKS
    resources :web_links, only: [:index, :create, :destroy], path: 'web-links'

    # SOCIAL STREAM
    resources :social_streams, only: [:index, :create, :update, :destroy], path: 'social-stream'
    scope path: 'social-stream', as: 'social_stream' do
      get ':stream_id/accounts/new' => 'social_streams#new_account', as: 'accounts_new'
      post ':stream_id/accounts' => 'social_streams#add_account', as: 'accounts'
      delete 'account/:id' => 'social_streams#destroy_account', as: 'account'
    end

    # CONNECTIONS
    get 'connections/:kind/show' => 'connections#connection_show', constraints: {
      :kind => /facebook|instagram|twitter/
    }
    get 'connections/facebook' => 'connections#connect_facebook'
    delete 'connections/facebook' => 'connections#disconnect_facebook'
    get 'connections/instagram' => 'connections#connect_instagram'
    delete 'connections/instagram' => 'connections#disconnect_instagram'
    get 'connections/twitter' => 'connections#connect_twitter'
    delete 'connections/twitter' => 'connections#disconnect_twitter'


    # COLORS
    resource :colors, only: [:show, :update]
  end

  namespace :stores_settings, path: 'appstore-settings' do
    # APP STORES
    resource :description, only: :show
    scope path: 'description', as: 'description' do
      patch 'ios' => 'descriptions#update_ios'
      patch 'android' => 'descriptions#update_android'
    end

    # APP ICON
    resource :app_icon, only: [:show, :update], path: 'app-icon'

    # APP SCREENSHOTS
    resources :screenshots, only: [:index, :create, :destroy]
  end

  namespace :extensions, path: 'app-extensions' do
    # COUPONS
    resource :coupons, only: [:show, :update]
    scope path: 'coupons', as: 'coupons' do
      post 'coupon_infos' => 'coupons#add_coupon_info'
      delete 'coupon_info/:id' => 'coupons#destroy_coupon_info', as: :coupon_info
    end

    # CONTACT US
    resource 'contacts', only: [:show, :update], path: 'contact-us', as: 'contact_us'
    scope path: 'contact-us', as: 'contact_us' do
      post 'locations' => 'contacts#add_location'
      delete 'location/:id' => 'contacts#destroy_location', as: :location
    end

    # PDF
    resources :pdf_files, only: [:index, :create, :destroy], path: 'pdf-viewer'

    # SHOPIFY
    resource :shopify, only: [:show, :update]

    # OPENTABLE
    resource :open_table, only: [:show, :update], path: 'opentable', as: 'opentable'
  end

  namespace :accounts, path: 'account' do
    # PACKAGES
    resource :packages, only: [:show, :update], path: 'appease-packages', as: 'appease_packages'

    # BILLING INFO
    resource :billing_info, only: [:show, :update], path: 'billing-info'
    post 'billing-info/coupon' => 'billing_infos#add_coupon'

    # ADDONS
    get 'add-ons' => 'addons#show'
    post 'add-ons/order' => 'addons#place_order'

    # BILLING HISTORY
    get 'billing-history' => 'billing_history#index'
    scope path: 'billing-history', as: 'billing_history' do
      get 'invoice/:id' => 'billing_history#invoice', as: :invoice
      get 'invoice/:id/print' => 'billing_history#invoice_print', as: :invoice_print
    end
  end

  scope :publish, as: 'publish' do
    get '' => 'publish#step_one'
    get 'step-one' => 'publish#step_one'
    post 'step-one' => 'publish#step_one_done'
    get 'step-two' => 'publish#step_two'
    post 'email-preview-links' => 'publish#email_preview_links'
    get 'step-three' => 'publish#step_three'
    post 'done' => 'publish#publish'
  end

  scope :wizard, as: 'new_user_wizard' do
    get '' => 'new_user_wizard#wizard'
    get 'companies' => 'new_user_wizard#companies'
    post 'companies' => 'new_user_wizard#set_company'
    get 'step-two' => 'new_user_wizard#step_two'
    patch 'step-two' => 'new_user_wizard#step_two_done'
    get 'step-three' => 'new_user_wizard#step_three'
    get 'step-four' => 'new_user_wizard#step_four'
    post 'step-four' => 'new_user_wizard#step_four_done'
  end

  scope path: 'quick-start', as: 'quick_start' do
    get '' => 'quick_start#show'
    get '/links' => 'quick_start#links'
    post '' => 'quick_start#create_user'
  end
end
