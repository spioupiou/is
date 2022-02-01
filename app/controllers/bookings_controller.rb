class BookingsController < ApplicationController

  def index
    if current_user.renter?
      if params[:status]
        @bookings = Booking.where(status: params[:status], user_id: current_user.id)
      else
        @bookings = Booking.where(user_id: current_user.id).order(:status)
      end
    else
      redirect_to kondos_path
    end
 end

  # def new
  #   @kondo = Kondo.find(params[:kondo_id])
  #   @booking = Booking.new
  # end

  def create
    @booking = Booking.new(user_id: current_user.id, kondo_id: params[:kondo_id], booked_date: params[:booking][:booked_date])

    # NOTE: that booking status defaults to "waiting"
    if @booking.save
      redirect_to bookings_path # Index of all bookings
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
    
    redirect_to kondo_path(@kondo)
  end

  private

  def booking_params
    params.require(:booking).permit(:booked_date, :status)
  end
end
