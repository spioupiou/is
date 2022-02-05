class KondosController < ApplicationController
  before_action :set_kondo, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # For unauthenticated users and renters
    if !user_signed_in? || current_user.renter?
      @kondos = policy_scope(Kondo).order(created_at: :desc)

      #Homepage search
      unless params[:search_kondos] == ""
        @kondos = policy_scope(Kondo).where("LOWER(prefecture) like ?","%#{params[:search_kondos].to_s.downcase}%")
      else
        @kondos = policy_scope(Kondo).all
      end

      #Index tab search

      if params[:search]
         @filter = params[:search]["tags"].push(params[:search]["prefecture"]).flatten.reject(&:blank?)
         @kondos = policy_scope(Kondo).all.global_search("#{@filter}")
      else
         @kondos = policy_scope(Kondo).all
      end
    # Provider's Page
    else
      @kondos = policy_scope(Kondo).where(user_id: current_user.id)

      # Retrieve all bookings associated to the kondos of that specific user
      @bookings = Booking.where(kondo_id: @kondos, status: ['waiting', 'confirmed'])

      # Transform the bookings in markers
      @markers = @bookings.geocoded.map do |booking|
      {
        lat: booking.latitude,
        lng: booking.longitude,
        info_window: render_to_string(partial: "info_window", locals: { booking: booking }),
        image_url: helpers.asset_url('house-logo.png')
      }
      end
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  def show
    @kondo = Kondo.find(params[:id])
    @booking = Booking.new
    @review = Review.new
    authorize @kondo

    # returns a hash loaded with information
    # user_type: "renter" / "provider" / "visitor"
    # booking:
    #   from kondo index or home page: most recent booking(object) of the renter for @kondo, nil if user is visitor or provider
    #   from bookings index: the booking itself
    # can_review?, can_book?, is_kondo_creator?: boolean
    # book_now: "Book again!" / "Book now!"
    # sample hash for renter that can reivew: { :user_type=>"renter", booking: booking-object, :can_review?=>true,
    # :can_book?=>true, :booking_btn_caption=> "Book now!" or "Book again!", :is_kondo_creator?=>false }

    @user = analyze_user(@kondo, params[:booking_id])
    # raise
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
    params.require(:kondo).permit(:name, :summary, :details, :prefecture, :price, :tag_list)
  end

  # TODO: can add as helper method to be more dry
  def analyze_user(kondo, booking_id)
    if user_signed_in?
      if current_user.renter?
        user_type = "renter"

        # get_the_right_booking will return either: the most recent booking for a specific kondo / the booking from booking index page
        booking = get_the_right_booking(kondo, booking_id)
        # find out if the user already made a review for the most recent completed booking of this kondo
        has_been_reviewed = Review.find_by(booking: booking)

        # check if there is a most recent booking
        if booking.present?

          # check if most recent booking status is completed
          if booking.completed?
            # show booking status instead of booking form
            can_book = true
            # booking form button as `Book again!` instead of `Book now!`
            book_now = false

            # use this flag to show review form if there are now reviews yet
            can_review = true if !has_been_reviewed
          else
            # this else block means booking status is not `completed`
            if booking.declined?
              can_book = true
              # method returns a boolean, true if renter had a completed booking of this kondo before, else false
              book_now = has_completed_a_booking_before
            end
            # this block means that the status is either `waiting` or `confirmed`, no code needed
            # we show booking status instead of booking form, renter can't book, can_book is false by default
          end
        else
          # this block means renter has never booked this kondo, booking.present? is nil
          can_book = true
          book_now = true
        end
      else
        # this block means user is a provider
        user_type = "provider"
        # find out if provider is the creator of the kondo
        is_kondo_creator = current_user.id == kondo.user.id
      end
    else
      user_type = "visitor"
      can_book = true
      book_now = true
    end

    # method returns this hash
    {
      # value after || will be used if value on left is nil
      user_type: user_type,
      booking: booking,
      can_review?: can_review || false,
      can_book?: can_book || false,
      booking_btn_caption: book_now ? "Book now!" : "Book again!",
      is_kondo_creator?: is_kondo_creator || false
    }
  end

  def get_the_right_booking(kondo, booking_id)
    if booking_id.present?
      # a renter clicks `See Details` from Bookings Index page
      Booking.find(booking_id)
    else
      # a user (renter/visitor/provider) clicks `See Details` from Kondo Index page
      # find most recent booking of renter for the kondo in the argument
      Booking.where(user: current_user, kondo: kondo).order(created_at: :asc).first
    end
  end

  def has_completed_a_booking_before
    # find all bookings for current user and  get the unqiue status of the bookings
    bookings = Booking.where(user: current_user).map(&:status).uniq
    # return true if the user has completed at least one booking
    bookings.include?("completed")
  end
end
