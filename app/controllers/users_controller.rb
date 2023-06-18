class UsersController < ApplicationController
  before_action :authenticate_user!, :active_branch

  def index
  
  end
end
