class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking, only: [:new, :create]

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

  private

  def review_params
    params.require(:review).permit(:score, :message)
  end

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end
end
