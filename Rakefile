# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

namespace :deploy do
  production_app = 'appease'
  staging_app = 'appease-staging'

  desc 'Deploy the app to production server'
  task :production do
    deploy production_app
  end

  desc 'Deploy the app to staging server'
  task :staging do
    deploy staging_app, 'staging'
  end

  desc 'Push environment keys to servers'
  task :keys do
    [production_app, staging_app].each do |app|
      system "heroku config:push --app #{app}"
    end
  end

  def deploy app, local_branch = 'master'
    remote = "git@heroku.com:#{app}.git"

    system "git push #{remote} #{local_branch}:master"
    system "heroku run rake db:migrate --app #{app}"
  end
end