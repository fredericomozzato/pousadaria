class SeasonalPricesController < ApplicationController
  def new
    get_rooms
    @seasonal_price = SeasonalPrice.new
  end

  def create
    @seasonal_price = SeasonalPrice.new(seasonal_params)
    if @seasonal_price.save
      redirect_to room_path(params[:seasonal_price][:room_id]),
                            notice: "Preço Sazonal criado com sucesso"
    else
      get_rooms
      flash.now[:alert] = "Erro ao criar Preço Sazonal"
      render :new
    end
  end

  private

  def seasonal_params
    params.require(:seasonal_price)
          .permit(:room_id, :start, :end, :price)
  end

  def get_rooms
    @rooms = Room.where("inn_id = ? AND active = ?", current_owner.inn.id, true)
  end
end
