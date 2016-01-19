# Ordered Product
class OrderedProduct < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :count, presence: true,
                    numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1 }
end
