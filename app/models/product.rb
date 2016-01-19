# Product
class Product < ActiveRecord::Base
  include SharedModelMethods
  mount_uploader :photo, ProductImageUploader

  belongs_to :category

  validates :name, presence: true, length: { maximum: 48 }
  validates :description, presence: true, length: { maximum: 840 }
  validates :price, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
end
