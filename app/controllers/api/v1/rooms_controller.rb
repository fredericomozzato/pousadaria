class Api::V1::RoomsController < Api::V1::ApiController
  def index
    inn = Inn.find_by(id: params[:inn_id], active: true)

    return inn_not_found if inn.nil?

    rooms = inn.rooms.where(active: true)
    render status: 200, json: rooms.as_json(only: room_permitted_attributes)
  end

  private

  def room_permitted_attributes
    [
      :id,
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
    ]
  end
end
