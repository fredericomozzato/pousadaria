class HomeController < ApplicationController
  before_action :redirect_to_new_if_no_inn, only: [:index]

  def index
    @recent_inns = Inn.order(created_at: :desc).where(active: true).limit(3)
    @inns = Inn.where.not(id: @recent_inns.map { |inn| inn.id }).where(active: true)
    @cities = Inn.all.where(active: true).map { |inn| inn.address.city }.uniq
  end

  def logins; end
end
