class BookingsController < ApplicationController
  def index
    @bookings = Booking.where(user_id: current_user.id)
  end

  def new
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.new
  end

  def create
    utc_date = date_params.to_s.to_time.utc
    booked_date = DateTime.parse(utc_date.to_s)
    @booking = Booking.new(user_id: current_user.id, kondo_id: params[:kondo_id], booked_date: booked_date)

    # NOTE: that booking status defaults to "waiting"
    if @booking.save
      redirect_to kondo_bookings_path # Index of all bookings
    else
      render :new
    end
  end

  private

  def date_params
    params.require(:booking).permit(:booked_date)
  end
end
