# Main Photos
class MainPhotosController < ApplicationController
  before_action :authenticate_user!

  def new
    if current_user.admin?
      if @main_description = MainDescription
                             .find_by('id = ?', params[:main_description_id])
        @main_photo = MainPhoto.new
      else
        flash[:alert] = t(:description_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def create
    if current_user.admin?
      if @main_description = MainDescription
                             .find_by('id = ?', params[:main_description_id])
        photos = attributes
        if photos.is_a?(Hash) &&
           photos[:photo].is_a?(Array) &&
           photos[:photo].length <= 100

          photos[:photo].each do |p|
            unless @main_description.main_photos.create(photo: p)
              flash[:alert] = t(:errors_present)
            end
          end

          if flash[:alert]
            redirect_to root_path
          else
            flash[:message] = t(:photo_has_been_added)
            redirect_to root_path
          end

        else
          flash[:alert] = t(:photo_data_problem)
          redirect_to root_path
        end

      else
        flash[:alert] = t(:description_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def destroy
    if current_user.admin?
      if @main_photo = MainPhoto.find_by('id = ?', params[:id])
        if @main_photo.destroy
          flash[:message] = t(:photo_has_been_deleted)
          redirect_to root_path
        else
          flash[:alert] = t(:photo_delete_problem)
          redirect_to root_path
        end
      else
        flash[:alert] = t(:photo_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  private

  def attributes
    return unless !params[:main_photo].blank? && params[:main_photo]
                                                 .is_a?(Hash)
    params.require(:main_photo).permit(photo: [])
  end
end
