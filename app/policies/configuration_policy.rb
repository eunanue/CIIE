class ConfigurationPolicy < ApplicationPolicy
  def edit?
    user.admin?
  end

  def update?
    edit?
  end
end
