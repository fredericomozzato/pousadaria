class HomeController < ApplicationController
  before_action :redirect_to_new_if_no_inn, only: [:index]

  def index
    @recent_inns = Inn.order(created_at: :desc).limit(3)
    @inns = Inn.where.not(id: @recent_inns.map { |inn| inn.id })
  end

  def logins
  end
end
