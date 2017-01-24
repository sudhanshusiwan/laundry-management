class Cloth < ActiveRecord::Base
  belongs_to :cloth_type
  belongs_to :order

  WASH_TYPE = %w[Laundry Dryclean]

  validates :cloth_type, presence: true
  validates :wash_type, presence: true, inclusion: {in: WASH_TYPE, message: 'Not a valid cloth type.'}
  validates :count, presence: true, numericality: { greater_than: 0 }
  validates :order, presence: true
  # validates_uniqueness_of :order_id, :scope => :cloth_type_id
  validates :cloth_type, uniqueness: { scope: [:order_id, :wash_type] }
end
