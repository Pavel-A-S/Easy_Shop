# Access
class AccessController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by('id = ?', params[:id]) if user_signed_in?
    if @user && (current_user.admin? || current_user.id == @user.id)
      render 'show'
    else
      flash[:alert] = t(:user_existence_problem)
      redirect_to root_path
    end
  end

  def edit
    @user = User.find_by('id = ?', params[:id]) if user_signed_in?
    if @user && (current_user.admin? || current_user.id == @user.id)
      render 'edit'
    else
      flash[:alert] = t(:user_existence_problem)
      redirect_to root_path
    end
  end

  def update
    @user = User.find_by('id = ?', params[:id]) if user_signed_in?
    if @user && (current_user.admin? || current_user.id == @user.id)
      @attributes = attributes
      if !current_user.admin? && @attributes && @attributes[:status]
        flash[:alert] = t(:operation_problem)
        redirect_to root_path
      elsif @user.update_attributes(attributes)
        flash[:message] = t(:user_has_been_updated)
        redirect_to access_path(@user)
      else
        flash.now[:alert] = t(:user_update_problem)
        render 'edit'
      end
    else
      flash[:alert] = t(:user_existence_problem)
      redirect_to root_path
    end
  end

  def destroy
    if current_user.admin?
      if @user = User.find_by('id = ?', params[:id])
        if @user.destroy
          flash[:message] = t(:user_has_been_deleted)
          redirect_to access_index_path
        else
          flash[:alert] = t(:user_delete_problem)
          redirect_to access_index_path
        end
      else
        flash[:alert] = t(:user_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def index
    if current_user.admin?
      @users = User.all.numbering(params[:list], 10, 5)
      authorize @users[:objects]
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  private

  def attributes
    return unless !params[:user].blank? && params[:user].is_a?(Hash)
    params.require(:user).permit(:name,
                                 :phone,
                                 :status)
  end
end
