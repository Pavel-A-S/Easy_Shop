# Customer Policy
class CustomerPolicy < ApplicationPolicy
  def index?
    user.admin?
  end
end
