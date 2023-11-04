class SeasonalPricesController < ApplicationController
  def new
    @rooms = Room.where("inn_id = ? AND active = ?", current_owner.inn.id, true)
    @seasonal_price = SeasonalPrice.new
  end

  def create
    @seasonal_price = SeasonalPrice.new(seasonal_params)
    @seasonal_price.save
    redirect_to room_path(params[:seasonal_price][:room_id]),
                          notice: "Período Sazonal criado com sucesso"
  end

  private

  def seasonal_params
    params.require(:seasonal_price)
          .permit(:room_id, :start, :end, :price)
  end
end
