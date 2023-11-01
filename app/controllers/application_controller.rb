class ApplicationController < ActionController::Base

  protected

  def redirect_to_new_if_no_inn
    if owner_signed_in? && !Inn.find_by(owner_id: current_owner.id)
      redirect_to new_inn_path, notice: "Cadastre sua Pousada!"
    end
  end
end
