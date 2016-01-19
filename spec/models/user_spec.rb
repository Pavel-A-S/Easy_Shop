require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @good_attributes = { name: 'Test',
                         phone: '12345678',
                         email: 'test@test.test',
                         password: '12345678',
                         password_confirmation: '12345678' }

    @wrong_attributes = { name: nil,
                          phone: nil,
                          email: 'Wrong email',
                          password: '1234567',
                          password_confirmation: nil }

    @second_wrong_attributes = { name: 'T' * 49,
                                 phone: '1' * 49,
                                 email: '12345678' * 5 + '@test.tes',
                                 password: '12345678',
                                 password_confirmation: '1234567' }
  end

  it 'Must not be errors if attributes are correct' do
    @user = User.create(@good_attributes)
    expect(@user.errors.size).to eq(0)
  end

  it 'Name must be present' do
    @user = User.create(@wrong_attributes)
    expect(@user.errors[:name].size).to eq(1)
  end

  it 'Name length must not be more than 48 symbols' do
    @user = User.create(@second_wrong_attributes)
    expect(@user.errors[:name].size).to eq(1)
  end

  it 'Phone must be present' do
    @user = User.create(@wrong_attributes)
    expect(@user.errors[:phone].size).to eq(1)
  end

  it 'Phone length must not be more than 48 symbols' do
    @user = User.create(@second_wrong_attributes)
    expect(@user.errors[:phone].size).to eq(1)
  end

  it 'Email must be present and be correct' do
    @user = User.create(@wrong_attributes)
    expect(@user.errors[:email].size).to eq(1)
  end

  it 'Email length must not be more than 48 symbols' do
    @user = User.create(@second_wrong_attributes)
    expect(@user.errors[:email].size).to eq(1)
  end

  it 'Password length must be at least 8 symbols' do
    @user = User.create(@wrong_attributes)
    expect(@user.errors[:password].size).to eq(1)
  end

  it 'Password and password confirmation must match' do
    @user = User.create(@second_wrong_attributes)
    expect(@user.errors[:password_confirmation].size).to eq(1)
  end
end
