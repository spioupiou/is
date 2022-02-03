class KondosController < ApplicationController
  before_action :set_kondo, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # For unauthenticated users and renters
    if !user_signed_in? || current_user.renter?
      @kondos = policy_scope(Kondo).order(created_at: :desc)

      unless params[:search_kondos] == ""
        @kondos = policy_scope(Kondo).where("LOWER(prefecture) like ?","%#{params[:search_kondos].to_s.downcase}%")
      else
        @kondos = policy_scope(Kondo).all
      end

    # Provider's Page
    else
      @kondos = policy_scope(Kondo).where(user_id: current_user.id)

      # Retrieve all bookings associated to the kondos of that specific user
      @bookings = Booking.where(kondo_id: @kondos)

      # Transform the bookings in markers
      @markers = @bookings.geocoded.map do |booking|
      {
        lat: booking.latitude,
        lng: booking.longitude,
        info_window: render_to_string(partial: "info_window", locals: { booking: booking }),
        image_url: helpers.asset_url('kondo-logo.png')
      }
      end
    end
  end

  def show
    @kondo = Kondo.find(params[:id])
    @booking = Booking.new
    authorize @kondo
  end

  def new
    @kondo = Kondo.new
    authorize @kondo
  end

  def edit
    authorize @kondo
  end

  def create
    @kondo = Kondo.new(kondo_params)
    @kondo.user_id = current_user.id

    authorize @kondo

    if @kondo.save
      redirect_to kondo_path(@kondo), notice: 'Kondo was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @kondo

    @kondo.update(kondo_params)

    if @kondo.save
      redirect_to kondo_path(@kondo), notice: 'Kondo was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @kondo

    @kondo.destroy
    redirect_to kondos_path, notice: 'Kondo was successfully destroyed.'
  end

  private

  def set_kondo
    @kondo = Kondo.find(params[:id])
  end

  def kondo_params
    params.require(:kondo).permit(:name, :summary, :details, :prefecture, :price)
  end
end
