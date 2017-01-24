class ClothType < ActiveRecord::Base
  has_many :cloths, :dependent => :destroy

  validates :name, presence: true
  validates :laundry_price, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :dryclean_price, :presence => true, :numericality => { :greater_than_or_equal_to => 0 }

  before_destroy :check_child, prepend: true


  private

  def check_child
    return true if self.cloths.nil?
    false
  end
end
