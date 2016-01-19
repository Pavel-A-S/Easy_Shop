# Main Description
class MainDescription < ActiveRecord::Base
  has_many :main_photos, dependent: :destroy
end
