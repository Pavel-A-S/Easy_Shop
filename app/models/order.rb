# Order
class Order < ActiveRecord::Base
  include SharedModelMethods

  has_many :ordered_products, dependent: :destroy

  enum status: [:opened, :await, :considered, :delivery, :finished]

  validates :customer_name, presence: true, length: { maximum: 48 }, on: :update
  validates :phone, presence: true, length: { maximum: 48 }, on: :update
  validates :email, length: { maximum: 48 }, on: :update
  validates :description, presence: true, length: { maximum: 840 }, on: :update
end
