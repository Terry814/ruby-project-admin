source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.7'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '~> 1.3.10'
  # for annotating models
  gem 'annotate', '~> 2.6.5'
  # for loading env variables from .env
  gem 'dotenv-rails', '~> 1.0.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.1.3'
  # Remove assets logs
  gem 'quiet_assets', '~> 1.0.3'
  # Use pry for debugging
  gem 'pry-byebug', '~> 2.0.0'
end

group :production, :staging do
  gem 'pg', '~> 0.17.1'
  # For better heroku support
  gem 'rails_12factor', '~> 0.0.3'
  # memcached
  gem 'dalli', '~> 2.7.2'
end

gem 'sidekiq'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

gem 'pjax_rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# for authentication
gem 'devise', '~> 3.4.1'

# for authorization
gem 'cancancan', '~> 1.9'

gem 'simple_form'
gem 'remotipart', '~> 1.2'

# assets
gem "font-awesome-rails", '~> 4.3.0'

# For HTTP requests
gem "httparty", '~> 0.13.3'

# Validators
gem "validate_url", '~> 0.2.2'
gem 'rfc-822', '~> 0.4.0' # email
gem 'phony_rails', '~> 0.12.11' # phone numbers
gem 'date_validator', '~> 0.7.1'
gem 'validates_existence', '~> 0.9.2' # for belongs_to with dummy new objects

# Reordering menu items
gem 'acts_as_list', '~> 0.5.0'

# for getting twitter info
gem 'twitter', '~> 5.13.0'

gem 'twilio-ruby', '~> 4.11.1'

# getting coordinates for locaations
gem 'geocoder', '~> 1.2.6'

# file uploads
gem 'paperclip', '~> 4.2'
gem 'aws-sdk', '~> 1.5.7'

gem 'stripe', '~> 1.16.0'
gem 'stripe_event', '~> 1.4.0'

# pagination
gem 'kaminari', '~> 0.16.1'

# login as user
gem "switch_user", '~> 0.9.5'

gem "koala", "~> 2.2"
gem 'intercom-rails', '~> 0.2.27'
gem 'intercom', "~> 2.4.4"

# Use unicorn as the app server
gem 'unicorn'
gem 'sucker_punch', '~> 1.1'

# For scarping
gem 'nokogiri'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

ruby '2.2.3'
