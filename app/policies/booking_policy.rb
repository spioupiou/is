class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end

    def new
      if current_user.renter?
        return true
      end
    end

    def create?
    end

    def edit?
      #Not too sure if the renter or provider can edit bookings. Will keep it as renter for now.
      current_user.renter?
  end

    def update?
      current_user.renter?
    end

    def destroy?
      current_user.renter?
    end
  end
end
