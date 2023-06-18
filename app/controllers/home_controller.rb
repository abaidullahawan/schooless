class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  layout 'home'
  def index

  end
end
