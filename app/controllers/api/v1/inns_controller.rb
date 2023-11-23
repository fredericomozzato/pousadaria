class Api::V1::InnsController < ActionController::API
  def index
    inns = Inn.joins(:address).where(active: true).where("name LIKE ?", "%#{params[:name]}%")

    render(status: 200, json: inns.as_json(
      except: [:corporate_name, :registration_number, :active],
      methods: [:formatted_check_in_time, :formatted_check_out_time, :average_score],
      include: { address: { except: [:created_at, :updated_at, :inn_id] } }
        )
      )
  end
end
