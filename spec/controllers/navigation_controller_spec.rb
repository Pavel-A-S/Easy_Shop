require 'rails_helper'

RSpec.describe NavigationController, type: :controller do
  fixtures :Users, :Orders

  before(:each) do
    @cookie_for_opened_order = 'opened_order'
    @cookie_for_not_opened_order = 'not_opened_order'
  end

  #------------------------------- Home --------------------------------------

  describe 'Home: ' do
    after(:each) do
      get :home
      expect(response).to render_template 'home'
    end

    it 'Unauthorized user must get access' do
    end

    it 'Customer must get access' do
      sign_in Users(:customer)
    end

    it 'Manager must get access' do
      sign_in Users(:manager)
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
    end
  end

  #------------------------------- Basket ------------------------------------

  describe 'Basket: ' do
    it 'Customer must be redirected if cookie is wrong' do
      cookies.signed[:customer_token] = @wrong_cookie
      get :basket
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:basket_is_empty))
    end

    it "Customer must not get access if order isn't 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_not_opened_order
      get :basket
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:basket_is_empty))
    end

    it "Customer must get access if order belongs to him and 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_opened_order
      get :basket
      expect(assigns(:order).status).to eq('opened')
      @order = assigns(:order).id
      expect(response).to redirect_to order_ordered_products_path(@order)
    end
  end

  #---------------------------------- Choice ---------------------------------

  describe 'Choice: ' do
    it 'Customer must be redirected if cookie is wrong' do
      cookies.signed[:customer_token] = @wrong_cookie
      get :choice
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:basket_is_empty))
    end

    it "Customer must not get access if order isn't 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_not_opened_order
      get :choice
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:basket_is_empty))
    end

    context "Customer must get access if order belongs to him and 'opened'" do
      it "Anonymous customer must get 'choice'" do
        cookies.signed[:customer_token] = @cookie_for_opened_order
        get :choice
        expect(assigns(:order).status).to eq('opened')
        expect(response).to render_template 'choice'
      end

      it 'Logged in customer must be redirected to fill-order-path' do
        sign_in Users(:customer)
        cookies.signed[:customer_token] = @cookie_for_opened_order
        get :choice
        expect(assigns(:order).status).to eq('opened')
        expect(response).to redirect_to fill_new_order_path
      end
    end
  end

  #---------------------------------- ****** ---------------------------------
end
