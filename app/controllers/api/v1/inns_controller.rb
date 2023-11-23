class Api::V1::InnsController < Api::V1::ApiController
  def index
    inns = Inn.joins(:address).where(active: true).where("name LIKE ?", "%#{params[:name]}%")

    render status: 200, json: inns.as_json(
      except: inn_filtered_attributes,
      methods: json_method_calls,
      include: { address: { except: address_filtered_attributes } }
    )
  end

  def show
    inn = Inn.find_by(id: params[:id], active: true)

    return render status: 404, json: {"erro": "Pousada não encontrada"} if inn.nil?
    render status: 200, json: inn.as_json(
      except: inn_filtered_attributes,
      methods: json_method_calls,
      include: { address: { except: address_filtered_attributes } }
    )
  end

  private

  def inn_filtered_attributes
    [
      :corporate_name,
      :registration_number,
      :active, :created_at,
      :updated_at,
      :owner_id
    ]
  end

  def address_filtered_attributes
    [:created_at, :updated_at, :inn_id]
  end

  def json_method_calls
    [
      :formatted_check_in_time,
      :formatted_check_out_time,
      :average_score
    ]
  end
end
