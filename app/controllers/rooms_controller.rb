class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :change_status, :remove_photo]
  before_action :authenticate_current_owner, only: [:edit, :update, :change_status, :remove_photo]
  before_action :authenticate_owner!, only: [:index, :new, :create, :edit,
                                             :update, :change_status, :remove_photo]

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
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @seasonal_prices = SeasonalPrice.where("room_id = ?", @room.id)
  end

  def edit; end

  def update
    @room.update(room_params)

    if @room.save
      redirect_to @room, notice: "Quarto atualizado com sucesso!"
    else
      flash.now[:alert] = "Erro ao atualizar quarto!"
      render :edit, status: :unprocessable_entity
    end
  end

  def change_status
    @room.active = !@room.active
    @room.save
    redirect_to @room, notice: "Quarto atualizado com sucesso!"
  end

  def remove_photo
    @room.photos.find_by(id: params[:photo_id]).purge
    redirect_to @room
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
      :accessibility,
      :active,
      photos: []
    )
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def authenticate_current_owner
    return redirect_to logins_path if current_owner.nil?

    if current_owner != @room.inn.owner
      redirect_to root_path, alert: "Você não tem permissão para acessar essa página!"
    end
  end
end
