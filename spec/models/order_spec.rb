require 'rails_helper'

RSpec.describe Order, type: :model do

  describe 'addition' do
    it 'adds two numbers' do
      sum = Order.add(5, 7)

      expect(sum).to eq(12)
    end
  end

  describe 'validation' do
    it 'checks valid object' do
      order = Order.new

      expect(order.valid?).to be_falsey
    end
  end
end