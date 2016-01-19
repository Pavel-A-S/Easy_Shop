# Category
class Category < ActiveRecord::Base
  has_many :child_categories, class_name: 'Category', foreign_key: 'category_id'
  #  has_many :products

  belongs_to :parent_category, class_name: 'Category',
                               foreign_key: 'category_id'

  validates :name, presence: true, length: { maximum: 48 }
  validates :category_type, presence: true
end
