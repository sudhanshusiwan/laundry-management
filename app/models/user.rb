class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders, :class_name => Order, :foreign_key => :customer_id
  has_many :picked_orders, :class_name => Order, :foreign_key => :picker_id
  has_many :dropped_orders, :class_name => Order, :foreign_key => :dropper_id
  has_one :store, :class_name => Store, :foreign_key => :owner_id
  has_many :addresses, :class_name => Address, :foreign_key => :owner_id

  ROLES = %w[customer admin pickup_boy store_owner]

  validates :role, :presence => true, inclusion: { in: User::ROLES, message: 'Not a valid operation area.' }

  def admin?
    self.role == 'admin'
  end

  def customer?
    self.role == 'customer'
  end

  def pickup_boy?
    self.role == 'pickup_boy'
  end

  def store_owner?
    self.role == 'store_owner'
  end

  def my_orders
    if self.admin?
      return Order.all
    elsif self.customer?
      return self.orders
    elsif self.store_owner? and self.store
      return (self.store.laundry_orders.where(:status => 'in-store') + self.store.dryclean_orders.where(:status => 'in-store')).uniq
    end
  end

  #orders which are open for drop
  def drop_orders
    return Order.where(:status => 'washed', :dropper_id => nil).where.not(:picker_id => nil) if self.pickup_boy?
  end

  #orders which are open for pickup
  def pick_orders
    return Order.where(:status => 'ordered', :dropper_id => nil, :picker_id => nil) if self.pickup_boy?
  end

  #orders to drop in store
  def to_store_orders
    Order.where(:status => 'picked')
  end

  #orders which pickup boy have choosed to pick but not yet picked
  def my_pick_orders
    return Order.where(:status => 'ordered', :picker_id => self.id) if self.pickup_boy?
  end

  #orders which pickup boy choosed to drop but not yet dropped
  def my_drop_orders
    return Order.where(:status => 'washed', :dropper_id => self.id) if self.pickup_boy?
  end
end
