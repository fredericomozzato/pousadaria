class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500
  rescue_from ActiveRecord::RecordNotFound, with: :return_404

  protected

  def inn_not_found
    render status: 404, json: {"erro": "Pousada não encontrada"}
  end

  private

  def return_404
    head 404
  end

  def return_500
    head 500
  end
end
