class PaperPolicy < ApplicationPolicy
  def index?
    user.admin? || user.professor?
  end

  def new?
    user.admin? || user.professor?
  end

  def create?
    user.admin? || user.professor?
  end

  def show?
    user.admin? || (user.professor? && record.participates?(user))
  end

  def edit
    user.admin? || (user.professor? && record.participates?(user))
  end

  def update?
    user.admin? || (user.professor? && record.participates?(user))
  end

  def destroy?
    user.admin?
  end

  def config?
    user.admin?
  end

  def evaluate?
    record.evaluator?(user)
  end

  def report?
    user.admin?
  end
end
