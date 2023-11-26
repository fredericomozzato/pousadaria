class Api::V1::ApiController < ActionController::API
  rescue_from StandardError, with: :return_500
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500
  rescue_from ActiveRecord::RecordNotFound, with: :return_404
  rescue_from NoMethodError, with: :return_404

  protected

  def inn_not_found
    render status: 404, json: {"erro": "Pousada não encontrada"}
  end

  private

  def return_404
    render status: 404, json: {"erro": "Recurso não encontrado"}
  end

  def return_500
    render status: 500, json: {"erro": "Tente novamente mais tarde"}
  end
end
