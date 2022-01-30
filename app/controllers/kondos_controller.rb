class KondosController < ApplicationController
  before_action :set_kondo, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    #For unauthenticated users and renters
    if !user_signed_in? || current_user.renter?
      @kondos = Kondo.order(created_at: :desc)

      unless params[:search_kondos] == ""
        @kondos = @kondos.where("LOWER(prefecture) like ?","%#{params[:search_kondos].to_s.downcase}%")
      else
        @kondos = Kondo.all
      end

    #Provider's Page
    else
      @kondos = Kondo.where(user_id: current_user.id)
    end
  end

  def show
    @kondo = Kondo.find(params[:id])
    @booking = Booking.new
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
