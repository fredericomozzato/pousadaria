class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_booking, only: [:new, :create, :answer]
  before_action :set_inn, only: [:index]
  before_action :authorize_access, only: [:new, :create]

  def index
    @reviews = @inn.reviews
  end

  def new
    @review = Review.new
    @room = @booking.room
    @inn = @room.inn
  end

  def create
    @review = @booking.build_review(review_params)

    if @review.save
      redirect_to @booking, notice: "Avaliação salva com sucesso"
    else
      @inn = @booking.room.inn
      flash.now[:alert] = "Erro ao criar avaliação"
      render "new"
    end
  end

  def answer
    review = @booking.review
    review.update(answer: params[:answer])

    redirect_to @booking, notice: "Resposta salva com sucesso"
  end

  private

  def review_params
    params.require(:review).permit(:score, :message)
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end

  def set_inn
    if owner_signed_in?
      @inn = current_owner.inn
    else
      @inn = Inn.find_by(params[:inn_id])
    end
  end

  def authorize_access
    unless current_user == @booking.user
      redirect_to root_path, alert: "Não foi possível completar a requisição"
    end
  end
end
