# Main Photo
class MainPhoto < ActiveRecord::Base
  mount_uploader :photo, MainPhotoUploader
  belongs_to :main_description
end
