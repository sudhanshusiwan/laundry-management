class Store < ActiveRecord::Base
  has_many :dryclean_orders, :class_name => Order, :foreign_key => :dryclean_store_id
  has_many :laundry_orders, :class_name => Order, :foreign_key => :laundry_store_id
  belongs_to :area
  belongs_to :owner, :class_name => User

  validates :name, :presence => true
  validates :owner, :presence => true, :uniqueness => true
  validates :area, :presence => true
  validates :operations, :presence => true, inclusion: { in: %w(Both Laundry Dryclean),
                                message: "Not a valid operation area." }

  def laundry_cloths_count
    return 0 if self.operations == 'Dryclean'
    store = Store.includes(laundry_orders: :cloths).find(self.id)
    count = 0
    store.laundry_orders.each do |laundry_orders|
      count = count + laundry_orders.cloths.where(:wash_type => 'Laundry').sum(:count)
    end
    count
  end

  def dryclean_cloths_count
    return 0 if self.operations == 'Laundry'
    store = Store.includes(dryclean_orders: :cloths).find(self.id)
    count = 0
    store.dryclean_orders.each do |dryclean_orders|
      count = count + dryclean_orders.cloths.where(:wash_type => 'Dryclean').sum(:count)
    end
    count
  end
end
