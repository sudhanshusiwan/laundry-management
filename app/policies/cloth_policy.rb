class ClothPolicy < ApplicationPolicy
  def index?
    if user.customer?
      record.all? {|cloth| cloth.order.customer_id == user.id}
    else
      user.pickup_boy? or user.admin? or user.store_owner?
    end
  end

  def edit?
    user.pickup_boy? or user.admin?
  end

  def update?
    edit?
  end

  def new?
    edit?
  end

  def create?
    new?
  end

  def destroy?
    new?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
