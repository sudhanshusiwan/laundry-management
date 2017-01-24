class Area < ActiveRecord::Base
  has_many :stores
  has_many :addresses

  validates :name, :presence => true
end
