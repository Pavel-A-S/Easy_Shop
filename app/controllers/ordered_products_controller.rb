# Order
class OrderedProductsController < ApplicationController
  def create
    if @order = prepare_order
      @ordered_product = @order.ordered_products.new(attributes)
      if @product = Product.find_by('id = ?', params[:product_id])
        @ordered_product.product_id = @product.id
        if @ordered_product.save
          flash[:message] = t(:added_to_basket)
          redirect_to products_path
        else
          flash[:alert] = t(:not_added_to_basket)
          redirect_to products_path
        end
      else
        flash[:alert] = t(:product_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:token_problem)
      redirect_to products_path
    end
  end

  def edit
    @ordered_product = OrderedProduct.find_by('id = ?', params[:id])
    if @ordered_product &&
       @ordered_product.order.status == 'opened' &&
       @ordered_product.order.customer_id == cookies.signed[:customer_token]
      render 'edit'
    else
      flash[:alert] = t(:product_operation_problem)
      redirect_to root_path
    end
  end

  def update
    @ordered_product = OrderedProduct.find_by('id = ?', params[:id])
    if @ordered_product &&
       @ordered_product.order.status == 'opened' &&
       @ordered_product.order.customer_id == cookies.signed[:customer_token]

      if @ordered_product.update_attributes(attributes)
        flash[:message] = t(:product_has_been_updated)
        redirect_to order_ordered_products_path(@ordered_product.order)
      else
        flash[:alert] = t(:product_update_problem)
        render 'edit'
      end

    else
      flash[:alert] = t(:product_operation_problem)
      redirect_to root_path
    end
  end

  def destroy
    @ordered_product = OrderedProduct.find_by('id = ?', params[:id])
    if @ordered_product &&
       @ordered_product.order.status == 'opened' &&
       @ordered_product.order.customer_id == cookies.signed[:customer_token]

      if @ordered_product.destroy
        flash[:message] = t(:product_has_been_deleted)
        redirect_to order_ordered_products_path(@ordered_product.order)
      else
        flash[:alert] = t(:product_delete_problem)
        redirect_to order_ordered_product_path(@ordered_product.order)
      end
    else
      flash[:alert] = t(:product_operation_problem)
      redirect_to root_path
    end
  end

  def index
    @order = Order.find_by('id = ?', params[:order_id])
    if @order && @order.status == 'opened' && (
       @order.customer_id == cookies.signed[:customer_token] ||
       (current_user && @order.customer_login == current_user.email))

      @ordered_products = @order.ordered_products
      render 'basket'

    elsif @order && current_user && ((current_user.admin? ||
                                      current_user.manager?) ||
                                      @order.customer_login == current_user
                                                               .email)

      @ordered_products = @order.ordered_products
      render 'index'
    else
      flash[:alert] = t(:operation_problem)
      redirect_to root_path
    end
  end

  private

  def prepare_order
    # check if token is right and order exists
    unless cookies.signed[:customer_token].blank?

      @order = Order.find_by('customer_id = ? and status = ?',
                             cookies.signed[:customer_token],
                             Order.statuses[:opened])

      # if cookie is wrong (Or order is closed) delete cookie
      cookies.delete(:customer_token) unless @order
    end

    # if order empty create new order and set cookie
    unless @order

      # generate unique token
      begin
        token = SecureRandom.urlsafe_base64
      end while Order.exists?(customer_id: token)

      # create token and customer
      cookies.permanent.signed[:customer_token] = token

      order_name = DateTime.now.strftime('%H.%M.%S_%d.%m.%Y')
      @order = Order.create(order_name: order_name,
                            customer_id: token,
                            status: :opened)
      @order.save
    end

    @order
  end

  def attributes
    return unless !params[:ordered_product].blank? &&
                  params[:ordered_product].is_a?(Hash)
    params.require(:ordered_product).permit(:count)
  end
end
