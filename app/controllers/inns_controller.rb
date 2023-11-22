class InnsController < ApplicationController
  before_action :authenticate_owner!, except: [:show, :search, :city_search, :advanced_search]
  before_action :redirect_to_new_if_no_inn, only: [:show, :my_inn]
  before_action :set_inn, only: [:show, :edit, :update, :change_status]


  def new
    if current_owner.inn
      redirect_to inn_path(current_owner.inn), notice: "Você já tem uma pousada cadastrada"
    else
      @inn = Inn.new
      @inn.build_address
    end
  end

  def create
    @inn = current_owner.build_inn(inn_params)
    @inn.check_in_time = get_time(:checkin_hour, :checkin_minute)
    @inn.check_out_time = get_time(:checkout_hour, :checkout_minute)

    if @inn.save
      redirect_to my_inn_path, notice: "Pousada criada com sucesso"
    else
      @address = @inn.address
      flash.now[:alert] = "Erro ao cadastrar Pousada"
      render :new
    end
  end

  def show
    @rooms = @inn.rooms.where(active: true)
    @average_score = @inn.average_score
  end

  def edit
    @address = @inn.address
  end

  def update
    @inn.check_in_time = get_time(:checkin_hour, :checkin_minute)
    @inn.check_out_time = get_time(:checkout_hour, :checkout_minute)
    @inn.address.update(inn_params[:address_attributes])

    if @inn.update(inn_params.except(:address_attributes))
      redirect_to my_inn_path, notice: "Pousada atualizada com sucesso"
    else
      @address = @inn.address
      flash.now[:alert] = "Erro ao atualizar Pousada"
      render :edit
    end
  end

  def my_inn
    @inn = current_owner.inn
    @rooms = @inn.rooms
  end

  def change_status
    @inn.active = !@inn.active

    if @inn.save
      redirect_to my_inn_path, notice: "Pousada editada com sucesso"
    else
      redirect_to my_inn_path, alert: "Erro ao editar Pousada"
    end
  end

  def search
    @inns = Inn.search_inns(params[:query]) if params[:query]
    @inns = Inn.advanced_search(advanced_params) if params[:advanced]
  end

  def city_search
    @found_inns = Inn.joins(:address)
                     .where(address: { city: params[:city] })
                     .order(:name)
  end

  private

  def inn_params
    params.require(:inn).permit(
      :name,
      :corporate_name,
      :registration_number,
      :phone,
      :email,
      :description,
      :pay_methods,
      :pet_friendly,
      :user_policies,
      :active,
      address_attributes: [
        :street,
        :number,
        :neighborhood,
        :city,
        :state,
        :postal_code
      ],
      date: [
        :checkin_hour,
        :chekin_minute,
        :checkout_hour,
        :checkout_minute
      ]
    )
  end

  def advanced_params
    params.permit(
      :name,
      :city,
      :pet_friendly,
      :accessibility,
      :wifi,
      :bathroom,
      :air_conditioner,
      :wardrobe,
      :tv,
      :porch,
      :safe
    )

  end

  def set_inn
    @inn = Inn.find(params[:id])
  end

  def get_time(hour, minute)
    Time.new(
      Time.now.year,
      Time.now.month,
      Time.now.day,
      params[:date][hour],
      params[:date][minute],
      0,
      "UTC"
    )
  end
end
