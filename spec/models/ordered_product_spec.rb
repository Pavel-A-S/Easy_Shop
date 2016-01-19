require 'rails_helper'

RSpec.describe OrderedProduct, type: :model do
  before(:each) do
    @good_attributes = { order_id: 1,
                         product_id: 1,
                         count: 17 }

    @wrong_attributes = { order_id: 1,
                          product_id: 1,
                          count: nil }

    @second_wrong_attributes = { order_id: 1,
                                 product_id: 1,
                                 count: 13.95 }

    @third_wrong_attributes = { order_id: 1,
                                product_id: 1,
                                count: -1 }
  end

  it 'Must not be errors if attributes are correct' do
    @ordered_product = OrderedProduct.create(@good_attributes)
    expect(@ordered_product.errors.size).to eq(0)
  end

  it 'Count must be present' do
    @ordered_product = OrderedProduct.create(@wrong_attributes)
    expect(@ordered_product.errors[:count].size).to be > 0
  end

  it 'Count must be an integer' do
    @ordered_product = OrderedProduct.create(@second_wrong_attributes)
    expect(@ordered_product.errors[:count].size).to eq(1)
  end

  it 'Count must be more than 0' do
    @ordered_product = OrderedProduct.create(@third_wrong_attributes)
    expect(@ordered_product.errors[:count].size).to eq(1)
  end
end
