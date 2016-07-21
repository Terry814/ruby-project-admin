class Accounts::BaseController < ApplicationController
  before_action :authenticate_user!
end