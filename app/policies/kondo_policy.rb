class KondoPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
    def new?
      current_user == 'provider'
    end

    def create?
      current_user == 'provider'
    end

    def update?
      current_user == 'provider'
    end

    def destroy?
      current_user == 'provider'
    end
  end
end
