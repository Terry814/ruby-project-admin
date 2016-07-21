require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Appease
  class Application < Rails::Application
    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    config.sass.load_paths << Rails.root.join('vendor', 'assets', 'components')

    config.autoload_paths << Rails.root.join("app", "events")

    config.autoload_paths << Rails.root.join("lib")

    config.generators.test_framework false

    config.paperclip_defaults = { 
        storage: :s3, 
        s3_credentials: {
            access_key_id: ENV['S3_ACCESS_KEY_ID'],
            secret_access_key: ENV['S3_SECRET_ACCESS_KEY']
        },
        s3_protocol: 'https',
        bucket: ENV['S3_BUCKET_NAME'],
        path: ":class/:attachment/:id_partition/:style/:filename",
        url: ":class/:attachment/:id_partition/:style/:filename",
        default_url: ""
    }

    config.time_zone = 'Central Time (US & Canada)'
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
