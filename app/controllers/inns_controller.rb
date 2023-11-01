class InnsController < ApplicationController
  before_action :authenticate_owner!

  def new
    @inn = Inn.new
  end

  def create
    @inn = Inn.new(inn_params)
    @inn.owner_id = current_owner.id
    @inn.check_in_time = get_time(:checkin_hour, :checkin_minute)
    @inn.check_out_time = get_time(:checkout_hour, :checkout_minute)

    if @inn.save
      redirect_to inn_path(@inn), notice: "Pousada criada com sucesso"
    else
      render :new
    end
  end

  def show
    set_inn
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
