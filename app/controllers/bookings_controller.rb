class BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:my_bookings, :create]
  before_action :authenticate_owner!, only: [:index, :check_in, :check_out, :active]
  before_action :authenticate_user_or_owner, only: [:show, :cancel]
  before_action :set_booking, only: [:show, :cancel, :check_in, :check_out]
  before_action :set_room, only: [:new, :create, :confirmation]
  before_action :set_inn, only: [:new, :confirmation]
  before_action -> { authorize_access(@booking) }, only: [:show, :check_out, :check_in, :cancel]

  def index
    @inn = current_owner.inn
    @bookings = @inn.bookings.order(:start_date)
  end

  def new
    @pre_booking = Booking.new
  end

  def confirmation
    @pre_booking = Booking.new

    if session["pre_booking"]
      @pre_booking.assign_attributes(session_params)
    else
      @pre_booking = Booking.new(pre_booking_params)
    end

    if @pre_booking.valid?
      session["pre_booking"] ||= pre_booking_params
    else
      render "new"
    end
  end

  def create
    @booking = @room.bookings.build()

    if session["pre_booking"]
      @booking.assign_attributes(session_params)
    end

    @booking.user = current_user

    if @booking.save
      session.delete("pre_booking")
      redirect_to booking_path(@booking), notice: "Reserva confirmada"
    else
      render "confirmation"
    end
  end

  def show
    @room = @booking.room
    @inn = @room.inn
    @review = @booking.review
  end

  def my_bookings
    @bookings = current_user.bookings.where.not(status: :closed)
    @closed_bookings = current_user.bookings.where(status: :closed)
  end

  def active
    @active_bookings = current_owner.inn.bookings.where(status: :active)
  end

  def cancel
    if current_user
      @booking.canceled! if @booking.confirmed? && Date.today.before?(@booking.cancel_date)
      return redirect_to booking_path(@booking), alert: "Não foi possível cancelar a reserva" unless @booking.canceled?
      redirect_to booking_path(@booking), notice: "Reserva cancelada"

    elsif current_owner
      @booking.canceled! if @booking.confirmed? && Date.today >= @booking.start_date + 2.days
      return redirect_to booking_path(@booking), alert: "Não foi possível cancelar a reserva" unless @booking.canceled?
      redirect_to booking_path(@booking), notice: "Reserva cancelada"

    else
      redirect_to booking_path(@booking), alert: "Não foi possível cancelar a reserva"
    end
  end

  def check_in
    if @booking.start_date <= Date.today

      @booking.guests.build(params[:guests].values)
      @booking.check_in = Time.current
      @booking.status = :active

      if @booking.save
        redirect_to @booking, notice: "Check-in realizado com sucesso"
      else
        redirect_to @booking, alert: "ERRO: Número de hóspedes maior que o informado na reserva"
      end
    else
      redirect_to @booking, alert: "Não foi possível realizar o check-in"
    end
  end

  def check_out
    if @booking.active?
      @booking.update(
        check_out: Time.current,
        status: :closed,
        pay_method: params[:pay_method],
        bill: @booking.calculate_bill
      )
      redirect_to @booking, notice: "Check-out realizado com sucesso"
    else
      redirect_to @booking, alert: "Não foi possível realizar o check-out"
    end
  end

  private

  def authenticate_user_or_owner
    unless user_signed_in? || owner_signed_in?
      redirect_to login_path, notice: "Faça log-in para continuar"
    end
  end

  def authorize_access(booking)
    if (current_owner&. != booking.room.inn.owner) || (current_user&. != booking.user)
      return redirect_to root_path, alert: "Não foi possível completar a requisição"
    end
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_inn
    @inn = @room.inn
  end

  def pre_booking_params
    params.permit(:start_date, :end_date, :number_of_guests, :room_id)
  end

  def booking_params
    params.require(:booking)
          .permit(:start_date, :end_date, :number_of_guests, :room_id)
  end

  def session_params
    { start_date: Date.parse(session.dig("pre_booking", "start_date")),
      end_date: Date.parse(session.dig("pre_booking", "end_date")),
      number_of_guests: session.dig("pre_booking", "number_of_guests").to_i,
      room_id: session.dig("pre_booking", "room_id").to_i }
  end
end
