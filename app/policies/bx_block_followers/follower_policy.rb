module BxBlockFollowers
  class FollowerPolicy < ::BxBlockFollowers::ApplicationPolicy
    def index?
      true
    end

    def show?
      scope.where(:id => record.id).exists?
    end

    def create?
      true
    end
  end
end
