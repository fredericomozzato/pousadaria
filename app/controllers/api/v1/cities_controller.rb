class Api::V1::CitiesController < Api::V1::ApiController
  def index
    cities = Inn.joins(:address).where(active: true).pluck(:city).sort

    render status: 200, json: {"cidades": cities}
  end
end
