class BookingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all # index of bookings
    end
  end

  def create?
    # only renters can create bookings
    user.renter?
  end

  def update?
    # allow the provider to change status || allow the renter to change his booking
    record.kondo.user == user || record.user == user
  end

  def destroy?
    # only the owner of the booking can delete the booking
    record.user == user
  end
end
