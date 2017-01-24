class Address < ActiveRecord::Base
  belongs_to :owner, :class_name => User
  belongs_to :area
  has_many :orders

  validates :owner, :presence => true
  validates :line1, :presence => true
  validates :pin, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :city, :presence => true
  validates :area, :presence => true


  def address_text
    self.line1.to_s + ', ' + self.line2.to_s + ', ' + self.area.name.to_s + ', ' + self.city.to_s + '-' + self.pin.to_s
  end
end
