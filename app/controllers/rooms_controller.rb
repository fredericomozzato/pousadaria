class RoomsController < ApplicationController
  before_action :set_room, only: [:show]

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.inn = current_owner.inn

    if @room.save
      redirect_to @room, notice: "Quarto cadastrado com sucesso!"
    else
    end
  end

  def show
    
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
