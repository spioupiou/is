class ProfilesController < ApplicationController
  skip_before_action :authenticate_user!

  def new
  end

  def show
      @user = User.find(params[:id])
      @profile = Profile.find(params[:id])
      @kondos = Kondo.where(user_id: @user.id)
      @bookings = Booking.where(kondo_id:@kondos.map(&:id))
      @reviews = Review.where(booking_id: @bookings.map(&:id))


  end

  def edit
  end

  def update
  end
end
