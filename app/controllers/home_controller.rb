class HomeController < ApplicationController
  before_action :check_if_owner_has_inn, only: [:index]

  def index

  end

  def logins
  end
end
