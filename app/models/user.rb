# User
class User < ActiveRecord::Base
  include SharedModelMethods

  def self.policy_class
    AccessPolicy
  end

  enum status: [:customer, :manager, :admin]

  validates :name, presence: true, length: { maximum: 48 }
  validates :phone, presence: true, length: { maximum: 48 }
  validates :email, length: { maximum: 48 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
