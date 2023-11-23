class Api::V1::RoomsController < Api::V1::ApiController
  def index
    inn = Inn.find_by(id: params[:inn_id], active: true)

    return inn_not_found if inn.nil?
    rooms = inn.rooms.where(active: true)
    render status: 200, json: rooms.as_json(
      except: [:created_at, :updated_at, :inn_id]
    )
  end
end
