# Navigation Controller
class NavigationController < ApplicationController
  def home
    @main_descriptions = MainDescription.all
  end

  def basket
    if @order = Order.find_by('customer_id = ? and status = ?',
                              cookies.signed[:customer_token],
                              Order.statuses[:opened])
      redirect_to order_ordered_products_path(@order)
    else
      flash[:message] = t(:basket_is_empty)
      redirect_to products_path
    end
  end

  def choice
    if @order = Order.find_by('customer_id = ? and status = ?',
                              cookies.signed[:customer_token],
                              Order.statuses[:opened])

      if user_signed_in?
        redirect_to fill_new_order_path
      else
        render 'choice'
      end

    else
      flash[:message] = t(:basket_is_empty)
      redirect_to products_path
    end
  end
end
