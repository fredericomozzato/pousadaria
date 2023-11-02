class InnsController < ApplicationController
  before_action :authenticate_owner!
  before_action :redirect_to_new_if_no_inn, only: [:show, :my_inn]


  def new
    @inn = Inn.find_by(owner_id: current_owner.id)
    if @inn
      redirect_to inn_path(@inn), notice: "Você já tem uma pousada cadastrada"
    else
      @inn = Inn.new
      @inn.build_address
    end
  end

  def create
    @owner = current_owner
    @inn = @owner.build_inn(inn_params)
    @inn.check_in_time = get_time(:checkin_hour, :checkin_minute)
    @inn.check_out_time = get_time(:checkout_hour, :checkout_minute)

    if @inn.save
      redirect_to minha_pousada_path, notice: "Pousada criada com sucesso"
    else
      @address = @inn.address
      flash.now[:alert] = "Erro ao cadastrar Pousada"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    set_inn
  end

  def edit
    set_inn
    @address = Address.find_by(inn_id: @inn.id)
  end

  def update
    set_inn
    @inn.check_in_time = get_time(:checkin_hour, :checkin_minute)
    @inn.check_out_time = get_time(:checkout_hour, :checkout_minute)

    @address = @inn.address
    @address.update(inn_params[:address_attributes])
    
    if @inn.update(inn_params.except(:address_attributes))
      redirect_to minha_pousada_path, notice: "Pousada atualizada com sucesso"
    else
      flash.now[:alert] = "Erro ao atualizar Pousada"
      render :edit, status: :unprocessable_entity
    end
  end

  def my_inn
    @inn = Inn.find_by(owner_id: current_owner.id)
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
