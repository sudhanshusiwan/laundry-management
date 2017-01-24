class OrderPolicy < ApplicationPolicy
  attr_reader :user, :order

  def initialize(user, order)
    @user = user
    @order = order
  end

  def create?
    user.customer? or user.admin?
  end

  def new?
    user.customer? or user.admin?
  end

  def edit?
    user.customer? or user.admin?
  end

  def update?
    user.customer? or user.admin?
  end

  def cancel?
    user.customer? or (user.admin? or order.customer == user) and order.cancellable?
  end

  def pick?
    (user.pickup_boy? or user.admin?) and order.pickable?(user)
  end

  def wont_pick?
    (user.pickup_boy? or user.admin?) and order.unpickable?(user)
  end

  def in_store?
    (user.pickup_boy? and order.picked?) or user.admin?
  end

  def drop?
    (user.pickup_boy? or user.admin?) and order.droppable?(user)
  end

  def wont_drop?
    (user.pickup_boy? or user.admin?) and order.undroppable?(user)
  end

  def dropped?
    (user.pickup_boy? or user.admin?) and order.undroppable?(user)
  end

  def washed?
    user.store_owner? or user.admin?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
