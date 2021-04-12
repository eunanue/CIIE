class EvaluationPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def edit
    user.admin? || (user.professor? && record.is_owner?(user))
  end

  def update?
    user.admin? || (user.professor? && record.is_owner?(user))
  end

  def report?
    user.admin?
  end
end