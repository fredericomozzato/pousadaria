class HomeController < ApplicationController
  before_action :redirect_to_new_if_no_inn, only: [:index]

  def index

  end

  def logins
  end
end
