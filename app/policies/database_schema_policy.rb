class DatabaseSchemaPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def export?
    @user.admin?
  end

  def edit?
    update?
  end

  def update?
    @user.admin?
  end

  def sync_tables?
    @user.admin?
  end

  def export_hive?
    @user.admin?
  end
end
