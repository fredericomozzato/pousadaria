class Api::V1::InnsController < Api::V1::ApiController
  def index
    inns = Inn.joins(:address)
              .where(active: true)
              .where("name LIKE ?", "%#{params[:name]}%")

    render status: 200, json: inns.as_json(
      only: inn_permitted_attributes,
      methods: json_method_calls,
      include: { address: { only: address_permitted_attributes } }
    )
  end

  def show
    inn = Inn.find_by(id: params[:id], active: true)

    return inn_not_found if inn.nil?

    render status: 200, json: inn.as_json(
      only: inn_permitted_attributes,
      methods: json_method_calls,
      include: { address: { only: address_permitted_attributes } }
    )
  end

  def cities
    if params[:city].present?
      inns = Inn.from_city(params[:city])

      render status: 200, json: inns.as_json(
        only: inn_permitted_attributes,
        include: { address: { only: address_permitted_attributes } }
      )
    else
      render status: 200, json: {"cidades": Inn.all_cities}
    end
  end

  private

  def inn_permitted_attributes
    [
      :id,
      :name,
      :phone,
      :email,
      :description,
      :pay_methods,
      :pet_friendly,
      :user_policies
    ]
  end

  def address_permitted_attributes
    [
      :street,
      :number,
      :neighborhood,
      :city, :state,
      :postal_code
    ]
  end

  def json_method_calls
    [
      :formatted_check_in_time,
      :formatted_check_out_time,
      :average_score
    ]
  end
end
