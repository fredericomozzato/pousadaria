class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @booking = Booking.find(params[:booking_id])
    @room = @booking.room
    @inn = @room.inn
  end
end
