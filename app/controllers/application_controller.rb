class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :cpf])
  end


  def redirect_to_new_if_no_inn
    if owner_signed_in? && !Inn.find_by(owner_id: current_owner.id)
      redirect_to new_inn_path, notice: "Cadastre sua Pousada!"
    end
  end
end
