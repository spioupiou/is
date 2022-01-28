class BookingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bookings = Booking.where(user_id: current_user.id)
  end

  def new
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.new
    if current_user.renter?
      authorize @booking
    else
    redirect_to root_path
    end
  end

  def create
    @booking = Booking.new(user_id: current_user.id, kondo_id: params[:kondo_id], booked_date: params[:booking][:booked_date])
    authorize @booking

    # NOTE: that booking status defaults to "waiting"
    if @booking.save
      redirect_to kondo_bookings_path # Index of all bookings
    else
      @kondo = Kondo.find(params[:kondo_id])
      render :new
    end
  end

  def edit
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.find(params[:id])
    authorize @booking
  end

  def update
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.find(params[:id])
    @booking.update(booking_params)
    authorize @booking

    redirect_to kondo_path(@kondo)
  end

  private

  def booking_params
    params.require(:booking).permit(:booked_date, :status)
  end
end
