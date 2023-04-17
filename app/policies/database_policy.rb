class DatabasePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all if @user.admin?
    end
  end

  def index?
    @user.admin?
  end

  def sync_schemas?
    @user.admin?
  end
end
