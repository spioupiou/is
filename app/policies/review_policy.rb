class ReviewPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all # index of index
    end
  end

  # allow reivew creation if renter is booking user_id
  def create?
    user.id == record.user_id
  end
end
