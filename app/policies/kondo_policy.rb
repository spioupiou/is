class KondoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end

    def new?
      current_user.provider?
    end

    def create?
      current_user.provider?
    end

    def edit?
      current_user.id == kondo.user_id
    end

    def update?
      current_user.id == kondo.user_id
    end

    def destroy?
      current_user.id == kondo.user_id
    end
  end
end
