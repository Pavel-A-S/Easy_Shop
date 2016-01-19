# Orders
class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:fill, :processing]

  def show
    if current_user.manager? || current_user.admin?
      @order = Order.find_by('id = ?', params[:id])
    elsif current_user.customer?
      @order = Order.find_by('id = ? and customer_login = ?',
                             params[:id],
                             current_user.email)
    else
      flash[:alert] = t(:who_are_you)
      redirect_to root_path
    end

    begin
      flash[:alert] = t(:order_existence_problem)
      redirect_to root_path
    end unless @order
  end

  def index
    if current_user.customer?
      @orders = Order.where('customer_login = ?',
                            current_user.email).numbering(params[:list], 10, 5)
      render 'customer_index'
    elsif current_user.manager?
      @orders = Order.all.numbering(params[:list], 10, 5)
      render 'manager_index'
    elsif current_user.admin?
      @orders = Order.all.numbering(params[:list], 10, 5)
      render 'index'
    else
      flash[:alert] = t(:who_are_you)
      redirect_to root_path
    end
    # authorize @orders[:objects]
  end

  def fill
    if @order = Order.find_by('customer_id = ? and status = ?',
                              cookies.signed[:customer_token],
                              Order.statuses[:opened])
      if user_signed_in?
        @order.customer_name = current_user.name
        @order.phone = current_user.phone
        @order.email = current_user.email
      end
      render 'fill'
    else
      flash[:alert] = t(:basket_is_empty)
      redirect_to products_path
    end
  end

  def edit
    if @order = Order.find_by('id = ?', params[:id])
      if current_user.customer? &&
         @order.await? && @order.customer_login == current_user.email
        render 'customer_edit'
      elsif current_user.manager?
        render 'manager_edit'
      elsif current_user.admin?
        render 'edit'
      else
        flash[:alert] = t(:order_change_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:order_existence_problem)
      redirect_to root_path
    end
  end

  def update
    @order = Order.find_by('id = ?', params[:id])
    if @order && (current_user.customer? || current_user.manager? ||
                                            current_user.admin?)
      if current_user.admin?
        handle @order.update_attributes(admin_attributes)
      elsif current_user.manager?
        handle @order.update_attributes(manager_attributes)
      elsif current_user.customer? &&
            @order.await? &&
            @order.customer_login == current_user.email
        handle @order.update_attributes(customer_attributes)
      else
        flash[:alert] = t(:who_are_you)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:order_change_problem)
      redirect_to root_path
    end
  end

  def processing
    if @order = Order.find_by('customer_id = ? and status = ?',
                              cookies.signed[:customer_token],
                              Order.statuses[:opened])

      if user_signed_in?
        customer_login = current_user.email
      else
        customer_login = 'anonymous'
      end

      additional_information = { status: :await,
                                 customer_login: customer_login,
                                 order_name: @order.id.to_s +
                                             DateTime
                                             .now
                                             .strftime('_%d.%m.%Y') }

      if @order.update_attributes(customer_attributes
                                  .merge(additional_information))
        flash[:message] = t(:order_has_been_created,
                            order_name: @order.order_name)
        redirect_to root_path
      else
        flash[:alert] = t(:order_data_change_problem)
        render 'fill'
      end

    else
      flash[:alert] = t(:order_existence_problem)
      redirect_to root_path
    end
  end

  def destroy
    if current_user.admin?
      if @order = Order.find_by('id = ?', params[:id])
        if @order.destroy
          flash[:message] = t(:order_has_been_deleted,
                              order_name: @order.order_name)
          redirect_to orders_path
        else
          flash[:alert] = t(:order_delete_problem,
                            order_name: @order.order_name)
          redirect_to orders_path
        end
      else
        flash[:alert] = t(:order_existence_problem)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:who_are_you)
      redirect_to root_path
    end
  end

  private

  def admin_attributes
    return unless !params[:order].blank? && params[:order].is_a?(Hash)
    params.require(:order).permit(:customer_name,
                                  :phone,
                                  :email,
                                  :description,
                                  :status_description,
                                  :status)
  end

  def manager_attributes
    return unless !params[:order].blank? && params[:order].is_a?(Hash)
    params.require(:order).permit(:status_description,
                                  :status)
  end

  def customer_attributes
    return unless !params[:order].blank? && params[:order].is_a?(Hash)
    params.require(:order).permit(:customer_name,
                                  :phone,
                                  :email,
                                  :description)
  end

  def handle(happened)
    if happened
      flash[:message] = t(:order_has_been_updated,
                          order_name: @order.order_name)
      redirect_to orders_path
    else
      flash[:alert] = t(:order_data_change_problem)
      render 'customer_edit' if current_user.customer?
      render 'manager_edit' if current_user.manager?
      render 'edit' if current_user.admin?
    end
  end
end
