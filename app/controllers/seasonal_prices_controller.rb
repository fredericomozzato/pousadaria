class SeasonalPricesController < ApplicationController
  def new
    @rooms = Room.where("inn_id = ? AND active = ?", current_owner.inn.id, true)
  end
end
