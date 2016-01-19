require 'rails_helper'

RSpec.describe Product, type: :model do
  before(:each) do
    @good_attributes = { name: 'Test',
                         description: '12345678',
                         price: 13.95 }

    @wrong_attributes = { name: nil,
                          description: nil,
                          price: nil }

    @second_wrong_attributes = { name: 'T' * 49,
                                 description: '1' * 841,
                                 price: -1 }
  end

  it 'Must not be errors if attributes are correct' do
    @product = Product.create(@good_attributes)
    expect(@product.errors.size).to eq(0)
  end

  it 'Name must be present' do
    @product = Product.create(@wrong_attributes)
    expect(@product.errors[:name].size).to eq(1)
  end

  it 'Name length must not be more than 48 symbols' do
    @product = Product.create(@second_wrong_attributes)
    expect(@product.errors[:name].size).to eq(1)
  end

  it 'Description must be present' do
    @product = Product.create(@wrong_attributes)
    expect(@product.errors[:description].size).to eq(1)
  end

  it 'Description length must not be more than 840 symbols' do
    @product = Product.create(@second_wrong_attributes)
    expect(@product.errors[:description].size).to eq(1)
  end

  it 'Price must be present' do
    @product = Product.create(@wrong_attributes)
    expect(@product.errors[:price].size).to be > 1
  end

  it 'Price must not be less than 0' do
    @product = Product.create(@second_wrong_attributes)
    expect(@product.errors[:price].size).to eq(1)
  end
end
