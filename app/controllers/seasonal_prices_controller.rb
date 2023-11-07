class SeasonalPricesController < ApplicationController
  before_action :authenticate_owner!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_room, only: [:new, :create]
  before_action :set_seasonal_price, only: [:edit, :update, :destroy]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

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
    @room_id = @seasonal_price.room_id
  end

  def update
    p @seasonal_price.id
    @seasonal_price.update!(seasonal_params)
    redirect_to room_path(@seasonal_price.room_id), notice: "Preço Sazonal atualizado com sucesso"
  end

  def destroy
    @seasonal_price.destroy!
    redirect_to room_path(@seasonal_price.room_id), notice: "Preço Sazonal excluído com sucesso"
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

  def authorize_owner
    if current_owner != @seasonal_price.room.inn.owner
      redirect_to root_path, alert: "Página não encontrada"
    end
  end
end
