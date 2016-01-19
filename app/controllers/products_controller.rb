# Products Controller
class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def new
    if current_user.admin? || current_user.manager?
      @product = Product.new
    else
      flash[:alert] = t(:product_operation_problem)
      redirect_to root_path
    end
  end

  def create
    if current_user.admin? || current_user.manager?
      @product = Product.new(attributes)
      if @product && @product.save
        flash[:message] = t(:product_has_been_added)
        redirect_to products_path
      else
        flash.now[:alert] = t(:product_add_problem)
        render 'new'
      end
    else
      flash[:alert] = t(:product_operation_problem)
      redirect_to root_path
    end
  end

  def edit
    if current_user.admin? || current_user.manager?
      @product = Product.find_by('id = ?', params[:id])
    else
      flash[:alert] = t(:product_operation_problem)
      redirect_to root_path
    end
  end

  def update
    if current_user.admin? || current_user.manager?
      @product = Product.find_by('id = ?', params[:id])
      if @product
        if @product.update_attributes(attributes)
          flash[:message] = t(:product_has_been_updated)
          redirect_to @product
        else
          flash.now[:alert] = t(:product_update_problem)
          render 'edit'
        end
      else
        flash[:alert] = t(:product_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:product_operation_problem)
      redirect_to root_path
    end
  end

  def destroy
    if current_user.admin? || current_user.manager?
      @product = Product.find_by('id = ?', params[:id])
      if @product
        if @product.destroy
          flash[:message] = t(:product_has_been_deleted)
          redirect_to products_path
        else
          flash[:alert] = t(:product_delete_problem)
          redirect_to products_path
        end
      else
        flash[:alert] = t(:product_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:product_operation_problem)
      redirect_to root_path
    end
  end

  def index
    @all_categories = Category.all.to_a
    @root_categories = @all_categories
                       .select { |object| object[:category_id].nil? }
    @categories = []
    recursion(@root_categories.sort_by(&:name), 0)
    @ordered_product = OrderedProduct.new

    # % - doesn't work! And check form!

    if params[:search]
      @products = Product.where('name LIKE ?',
                                "%#{params[:search]}%").numbering(params[:list],
                                                                  4, 5)
      @search = 'search=' + params[:search]
    elsif params[:category]
      @products = Product.where('category_id = ?',
                                params[:category]).numbering(params[:list],
                                                             4, 5)
      @search = 'category=' + params[:category]
    else
      @products = Product.all.numbering(params[:list], 4, 5)
    end
  end

  def show
    if @product = Product.find_by('id = ?', params[:id])
      render 'show'
    else
      flash[:alert] = t(:product_existence_problem)
      redirect_to root_path
    end
  end

  private

  def attributes
    return unless !params[:product].blank? && params[:product].is_a?(Hash)
    params.require(:product).permit(:name,
                                    :description,
                                    :category_id,
                                    :count,
                                    :price,
                                    :photo)
  end

  def recursion(root_categories, deep)
    root_categories.each do |rc|
      @categories << { object: rc, deep: deep }
      childs = @all_categories
               .select { |object| object[:category_id] == rc.id }
      recursion(childs, deep + 1)
    end
  end
end
