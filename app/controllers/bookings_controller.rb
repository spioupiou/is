class BookingsController < ApplicationController

  def index
    if params[:status]
      @bookings = policy_scope(Booking).where(status: params[:status], user_id: current_user.id)
    else
      @bookings = policy_scope(Booking).where(user_id: current_user.id).order(:status)
    end
    user_not_authorized if current_user.provider?
  end

  def create
    @booking = Booking.new(user_id: current_user.id, kondo_id: params[:kondo_id], booked_date: params[:booking][:booked_date])
    authorize @booking

    # NOTE: that booking status defaults to "waiting"
    if @booking.save
      redirect_to bookings_path(status: "waiting") # Index of all bookings
    else
      @kondo = Kondo.find(params[:kondo_id])
      render "kondos/show"
    end
  end

  def edit
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.find(params[:id])
  end

  def update
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.find(params[:id])
    @booking.update(booking_params)
    @booking.save
    authorize @booking
  end

  private

  def booking_params
    params.require(:booking).permit(:booked_date, :status)
  end
end
