require 'rails_helper'

RSpec.describe Order, type: :model do
  before(:each) do
    @good_attributes = { customer_name: 'Test',
                         phone: '12345678',
                         description: 'Test',
                         email: 'test@test.test' }

    @wrong_attributes = { customer_name: nil,
                          phone: nil,
                          description: nil,
                          email: nil }

    @second_wrong_attributes = { customer_name: 'T' * 49,
                                 phone: '1' * 49,
                                 description: 'T' * 841,
                                 email: '12345678' * 5 + '@test.tes' }
    @order = Order.create
  end

  it 'Must not be errors if attributes are correct' do
    @order.update_attributes(@good_attributes)
    expect(@order.errors.size).to eq(0)
  end

  it 'Customer name must be present' do
    @order.update_attributes(@wrong_attributes)
    expect(@order.errors[:customer_name].size).to eq(1)
  end

  it 'Customer name length must not be more than 48 symbols' do
    @order.update_attributes(@second_wrong_attributes)
    expect(@order.errors[:customer_name].size).to eq(1)
  end

  it 'Phone must be present' do
    @order.update_attributes(@wrong_attributes)
    expect(@order.errors[:phone].size).to eq(1)
  end

  it 'Phone length must not be more than 48 symbols' do
    @order.update_attributes(@second_wrong_attributes)
    expect(@order.errors[:phone].size).to eq(1)
  end

  it 'Description must be present' do
    @order.update_attributes(@wrong_attributes)
    expect(@order.errors[:description].size).to eq(1)
  end

  it 'Description length must not be more than 840 symbols' do
    @order.update_attributes(@second_wrong_attributes)
    expect(@order.errors[:description].size).to eq(1)
  end

  it 'Email can be not present' do
    @order.update_attributes(@wrong_attributes)
    expect(@order.errors[:email].size).to eq(0)
  end

  it 'Email length must not be more than 48 symbols' do
    @order.update_attributes(@second_wrong_attributes)
    expect(@order.errors[:email].size).to eq(1)
  end
end
