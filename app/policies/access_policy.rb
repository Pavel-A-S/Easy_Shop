# Access policy
class AccessPolicy < ApplicationPolicy
  def index?
    user.admin?
  end
end
