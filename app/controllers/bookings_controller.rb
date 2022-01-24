class BookingsController < ApplicationController
  def new
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.new
  end

  def create
    booked_date = date_formating(params[:booking])
    @booking = Booking.new(user_id: current_user.id, kondo_id: params[:kondo_id], booked_date: booked_date)

    if @booking.save
      redirect_to kondo_bookings_path # Index of all bookings
    else
      render :new
    end
  end

  private

  def date_formating(hash)
    DateTime.new(
      hash["booked_date(1i)"].to_i,
      hash["booked_date(2i)"].to_i,
      hash["booked_date(3i)"].to_i,
      hash["booked_date(4i)"].to_i,
      hash["booked_date(5i)"].to_i
    )
  end
end
