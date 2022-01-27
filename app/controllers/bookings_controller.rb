class BookingsController < ApplicationController
  def index
    @bookings = Booking.where(user_id: current_user.id)
  end

  def new
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(user_id: current_user.id, kondo_id: params[:kondo_id], booked_date: params[:booking][:booked_date])

    # note that booking status defaults to "waiting"
    if @booking.save
      redirect_to kondo_bookings_path # Index of all bookings
    else
      @kondo = Kondo.find(params[:kondo_id])
      render :new
    end
  end
end
