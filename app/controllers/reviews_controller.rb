class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @booking = Booking.find(params[:booking_id])
    @room = @booking.room
    @inn = @room.inn
  end

  def create
    @booking = Booking.find(params[:booking_id])
    @review = @booking.build_review(review_params)

    @review.save!
    redirect_to @booking, notice: "Avaliação salva com sucesso"
  end

  private

  def review_params
    params.require(:review).permit(:score, :message)
  end
end
