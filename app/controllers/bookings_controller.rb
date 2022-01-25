class BookingsController < ApplicationController
  def new
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.new
  end

  def create
    booked_date = DateTime.parse(date_params.to_s)
    @booking = Booking.new(user_id: current_user.id, kondo_id: params[:kondo_id], booked_date: booked_date)

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
