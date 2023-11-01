class InnsController < ApplicationController
  before_action :authenticate_owner!

  def new
    @inn = Inn.new
  end

  def create
    @inn = Inn.new(inn_params)
    @inn.save
    redirect_to inn_path(@inn), notice: "Pousada criada com sucesso"
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
      :check_in_time,
      :check_out_time,
      :active,
      address_attributes: [
        :street,
        :number,
        :neighborhood,
        :city,
        :state,
        :postal_code
      ]
    )
  end

  def set_inn
    @inn = Inn.find(params[:id])
  end
end
