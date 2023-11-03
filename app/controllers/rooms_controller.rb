class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update]
  before_action :authenticate_owner!, only: [:index, :new, :create]

  def index
    @inn = current_owner.inn
    @rooms = @inn.rooms
  end

  def new
    @room = Room.new
  end

  def create
    @room = current_owner.inn.rooms.build(room_params)
    if @room.save
      redirect_to @room, notice: "Quarto cadastrado com sucesso!"
    else
      flash.now[:alert] = "Erro ao cadastrar quarto!"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    @room.update(room_params)

    if @room.save
      redirect_to @room, notice: "Quarto atualizado com sucesso!"
    else
      flash.now[:alert] = "Erro ao atualizar quarto!"
      render :edit
    end
  end

  private

  def room_params
    params.require(:room).permit(
      :name,
      :description,
      :size,
      :max_guests,
      :price,
      :bathroom,
      :porch,
      :air_conditioner,
      :tv,
      :wardrobe,
      :safe,
      :wifi,
      :accessibility
    )
  end

  def set_room
    @room = Room.find(params[:id])
  end
end
