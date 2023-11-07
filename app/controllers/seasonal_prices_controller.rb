class SeasonalPricesController < ApplicationController
  before_action :set_room, only: [:new, :create]

  def new
      @seasonal_price = SeasonalPrice.new
  end

  def create
    @seasonal_price = @room.seasonal_prices.build(seasonal_params)
    if @seasonal_price.save
      redirect_to room_path(@room),
                            notice: "Preço Sazonal criado com sucesso"
    else
      flash.now[:alert] = "Erro ao criar Preço Sazonal"
      render :new
    end
  end

  def edit
    set_seasonal_price
    @room_id = @seasonal_price.room_id
  end

  def update
    set_seasonal_price
    p @seasonal_price.id
    @seasonal_price.update!(seasonal_params)
    redirect_to room_path(@seasonal_price.room_id), notice: "Preço Sazonal atualizado com sucesso"
  end

  private

  def seasonal_params
    params.require(:seasonal_price)
          .permit(:room_id, :start, :end, :price)
  end

  def set_seasonal_price
    @seasonal_price = SeasonalPrice.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:room_id])
  end
end
