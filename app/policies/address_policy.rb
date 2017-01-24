class AddressPolicy < ApplicationPolicy
  #
  # attr_reader :user, :address
  #
  # def initialize(user, address)
  #   @user = user
  #   @address = address
  # end

  def index?
    record.all? {|address| address.owner_id == user.id }
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
