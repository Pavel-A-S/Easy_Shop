require 'rails_helper'

RSpec.describe Category, type: :model do
  before(:each) do
    @good_attributes = { name: 'Test',
                         category_type: 'For search' }

    @wrong_attributes = { name: nil,
                          category_type: nil }

    @second_wrong_attributes = { name: '1' * 49,
                                 category_type: 'For search' }
  end

  it 'Must not be errors if attributes are correct' do
    @category = Category.create(@good_attributes)
    expect(@category.errors.size).to eq(0)
  end

  it 'Name must be present' do
    @category = Category.create(@wrong_attributes)
    expect(@category.errors[:name].size).to eq(1)
  end

  it 'Name length must not be more than 48 symbols' do
    @category = Category.create(@second_wrong_attributes)
    expect(@category.errors[:name].size).to eq(1)
  end

  it 'Category type must be present' do
    @category = Category.create(@wrong_attributes)
    expect(@category.errors[:category_type].size).to eq(1)
  end
end
