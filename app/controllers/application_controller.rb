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

  def after_sign_in_path_for(resource)
    if session["pre_booking"]
      room_id = session["pre_booking"]["room_id"]&.to_i
      flash[:notice] = "Finalize sua Reserva!"
      return confirmation_room_bookings_path(room_id)
    else
      root_path
    end
  end
end
