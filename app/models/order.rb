class Order < ActiveRecord::Base
  belongs_to :customer, :class_name => User
  belongs_to :picker, :class_name => User
  belongs_to :dropper, :class_name => User
  belongs_to :laundry_store, :class_name => Store
  belongs_to :dryclean_store, :class_name => Store
  has_many :cloths
  belongs_to :address

  validates :status, presence: true
  validates :customer, :presence => true
  validates :to_pick_date, :presence => true
  validate :pickup_date_cannot_be_in_the_past
  validates :to_pick_time, :presence => true
  # validate :pickup_time_cannot_be_in_the_past
  #TODO: validation for laundry store and dryclean store - xor wala
  # validates_presence_of :laundry_store_id
  # validates_presence_of :dryclean_store_id

  def nearby_laundry_stores(address_id)
    address = Address.find(address_id)
    address.area.stores.where.not(:operations => "Dryclean" )
  end

  def nearby_dryclean_stores(address_id)
    address = Address.find(address_id)
    address.area.stores.where.not(:operations => "Laundry" )
  end

  def picked?
    self.status == 'picked'
  end

  def cancel_order
    self.status = 'cancelled'
    self.save!
  end

  def cancellable?
    self.status == 'ordered'
  end

  def editable?
    cancellable?
  end

  def pickable?(user)
    # (self.status == 'ordered' and self.picker_id != nil)
    user.pick_orders.exists?(self.id)
  end

  def unpickable?(user)
    self.status == 'ordered' and self.picker_id == user.id
    # Order.where(:status => 'ordered', :dropper_id => nil).where.not(:picker_id => nil)
  end

  def droppable?(user)
    user.drop_orders.exists?(self.id)
  end

  #check if this order can be undropped - to authorize user before un-dropping it
  def undroppable?(user)
    self.status == 'washed' and self.dropper_id == user.id
    # Order.where(:status => 'washed', :dropper_id => user.id).where.not(:picker_id => nil) or !self.picked?
  end

  def set_picker(user_id)
    self.picker_id = user_id
    self.save!
  end

  def remove_picker
    self.picker_id = nil
    self.save!
  end

  def self.mark_picked(order_id)
    order = Order.find(order_id)
    return if order.picked?
    order.status = 'picked'
    order.pickup_time = Time.now
    order.save!
  end

  def mark_instore
    self.status = 'in-store'
    self.save!
  end

  def set_dropper(user_id)
    self.dropper_id = user_id
    self.save!
  end

  def remove_dropper
    self.dropper_id = nil
    self.save!
  end

  def mark_dropped
    self.status = 'dropped'
    self.drop_time = Time.now
    self.save!
  end

  def mark_washed
    self.status = 'washed'
    self.wash_comeplete_time = Time.now
    self.save!
  end

  def self.add(a, b)
    a + b
  end

  private

  def pickup_date_cannot_be_in_the_past
    errors.add(:to_pick_date, "can't be in the past") if
        !to_pick_date.blank? and to_pick_date < Date.today
  end

  def pickup_time_cannot_be_in_the_past
    errors.add(:to_pick_time, "can't be in the past") if
        !to_pick_time.blank? and to_pick_time < Time.now
  end
end
