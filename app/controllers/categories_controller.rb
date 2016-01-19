# Categories controller
class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def new
    if current_user.admin?
      @category = Category.new
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def index
    if current_user.admin?
      @categories = Category.all
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def create
    if current_user.admin?
      @category = Category.new(attributes)
      if @category &&
         (@category.category_id.blank? ||
          @parent_category = Category.find_by('id = ?', @category.category_id))

        if @parent_category &&
           @parent_category.category_type == 'For search'
          flash.now[:alert] = t(:category_parent_type_problem)
          render 'new'
        elsif @category.category_type == 'For search' ||
              @category.category_type == 'Section name'

          if @category.save
            flash[:message] = t(:category_has_been_created)
            redirect_to categories_path
          else
            flash.now[:alert] = t(:errors_present)
            render 'new'
          end

        else
          flash.now[:alert] = t(:category_type_problem)
          render 'new'
        end
      else
        flash.now[:alert] = t(:category_parent_problem)
        render 'new'
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def edit
    if current_user.admin?
      if @category = Category.find_by('id = ?', params[:id])
        render 'edit'
      else
        flash[:alert] = t(:category_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def update
    if current_user.admin?
      if @category = Category.find_by('id = ?', params[:id])
        if params[:category].is_a?(Hash)
          new_category_id = params[:category][:category_id].to_i
          new_category_type = params[:category][:category_type]

          if new_category_id == 0 || (@category.id != new_category_id &&
             Category.exists?(['id = ?', new_category_id]))

            @parent_category = Category.find_by('id = ?', new_category_id)

            if @parent_category &&
               @parent_category.category_type == 'For search'

              flash.now[:alert] = t(:category_parent_type_problem)
              render 'edit'
            elsif new_category_type == 'For search' &&
                  !@category.child_categories.blank?
              flash.now[:alert] = t(:category_has_subcategory)
              render 'edit'
            elsif new_category_type == 'For search' ||
                  new_category_type == 'Section name'

              if @category.update_attributes(attributes)
                flash[:message] = t(:category_has_been_updated)
                redirect_to categories_path
              else
                flash.now[:alert] = t(:category_update_problem)
                render 'edit'
              end

            else
              flash[:alert] = t(:category_type_problem)
              redirect_to root_path
            end
          else
            flash[:alert] = t(:category_parent_problem)
            redirect_to root_path
          end
        else
          flash[:alert] = t(:check_data)
          redirect_to root_path
        end
      else
        flash[:alert] = t(:category_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  def destroy
    if current_user.admin?
      if @category = Category.find_by('id = ?', params[:id])
        if @category.destroy
          flash[:message] = t(:category_has_been_deleted)
          redirect_to categories_path
        else
          flash[:alert] = t(:category_delete_problem)
          redirect_to categories_path
        end
      else
        flash[:alert] = t(:category_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  private

  def attributes
    return unless !params[:category].blank? && params[:category].is_a?(Hash)
    params.require(:category).permit(:name, :category_id, :category_type)
  end
end
