class BookingsController < ApplicationController
  def new
    @kondo = Kondo.find(params[:kondo_id])
    @booking = Booking.new
  end

  # Create
  # 1. Fetch the booked_date from the form params
  # 2. Fetch the kondo_id from params[:kondo_id]
  # 3. Fetch the user_id from current_user
  # 4. Create the new booking with those three parameters and
  # 5. Try to save
  # 6. If saved -> redirect
  # 7. If not saved -> render:new
end
