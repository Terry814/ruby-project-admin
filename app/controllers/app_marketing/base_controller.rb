class AppMarketing::BaseController < ApplicationController
  before_action :authenticate_user!
end
