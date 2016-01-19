# Main Descriptions
class MainDescriptionsController < ApplicationController
  before_action :authenticate_user!

  def new
    if current_user.admin?
      @main_description = MainDescription.new
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def edit
    if current_user.admin?
      if @main_description = MainDescription.find_by('id = ?', params[:id])
        render 'edit'
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
      if @main_description = MainDescription.find_by('id = ?', params[:id])
        if @main_description.destroy
          flash[:message] = t(:description_has_been_deleted)
          redirect_to root_path
        else
          flash[:alert] = t(:description_delete_problem)
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

  def create
    if current_user.admin?
      @main_description = MainDescription.new(attributes)
      if @main_description.save
        flash[:message] = t(:description_has_been_added)
        redirect_to root_path
      else
        flash.now[:alert] = t(:description_data_problem)
        render 'new'
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def update
    if current_user.admin?
      if @main_description = MainDescription.find_by('id = ?', params[:id])
        if @main_description && @main_description.update_attributes(attributes)
          flash[:message] = t(:description_has_been_updated)
          redirect_to root_path
        else
          flash.now[:alert] = t(:description_update_problem)
          render 'edit'
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

  private

  def attributes
    return unless !params[:main_description].blank? &&
                  params[:main_description].is_a?(Hash)
    params.require(:main_description).permit(:title, :description)
  end
end
