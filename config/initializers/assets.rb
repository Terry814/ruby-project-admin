# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'
Rails.application.config.assets.precompile += %w( ie.js )
Rails.application.config.assets.precompile << %r(bootstrap-sass/fonts/bootstrap/[\w-]+\.(?:eot|svg|ttf|woff2?)$)
Rails.application.config.assets.precompile += %w( pages.min.css themes.min.css )
