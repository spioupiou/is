class ReviewsController < ApplicationController
  def create
    # {"authenticity_token"=>"Kowm/Au6q50VtBVJ3NOyIzQjCLasVc5MzAXuUaMwqLoynA2yuwhhSMjrFY2J2Mmr7LNR4kcUUW+drM6YacFLeg==",
    #   "review"=>{"rating"=>"4", "comment"=>"test comment"},
    #   "commit"=>"Submit review",
    #   "kondo_id"=>"21",
    #   "booking_id"=>"37"}
    @review = Review.new(reviews_params)
    @review.booking_id = params[:booking_id]
    @review.user_id = current_user.id
    authorize @review

    if @review.save
      @user = analyze_user(params[:kondo_id], @review.booking_id)
      redirect_to kondo_path(params[:kondo_id])
    else
      @kondo = Kondo.find(params[:kondo_id])
      render "kondos/show"
    end
  end

  private

  def reviews_params
    params.require(:review).permit(:rating, :comment)
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
