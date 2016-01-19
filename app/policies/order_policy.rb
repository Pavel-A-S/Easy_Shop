# Order Policy
class OrderPolicy < ApplicationPolicy
  def index?
    user.admin? || user.manager? || user.customer?
  end
end
