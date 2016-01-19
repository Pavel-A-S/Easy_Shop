require 'rails_helper'

RSpec.describe OrderedProductsController, type: :controller do
  fixtures :OrderedProducts, :Orders, :Users

  before(:each) do
    @attributes = { count: 5 }
    @product = 96
    @product_in_opened_order = 1
    @product_in_not_opened_order = 2
    @no_existing_product = 69
    @wrong_cookie = 'wrong_cookie'

    @not_opened_customer_order = 5
    @opened_customer_order = 7
    @opened_order = 1
    @not_opened_order = 2
    @no_existing_order = 69

    @cookie_for_opened_order = 'opened_order'
    @cookie_for_not_opened_order = 'not_opened_order'
  end

  #---------------------------------- Create ---------------------------------

  describe 'Create: ' do
    it 'Any user must get access' do
      post :create, product_id: @product, ordered_product: @attributes
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:added_to_basket))
    end

    it 'If product not exist - user must be redirected' do
      post :create, product_id: @no_existing_product,
                    ordered_product: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_existence_problem))
    end

    it 'Cookie must be present' do
      post :create, product_id: @product, ordered_product: @attributes
      expect(cookies.signed[:customer_token]).not_to be_empty
    end

    it 'If cookie wrong - must be changed' do
      cookies.signed[:customer_token] = @wrong_cookie
      post :create, product_id: @product, ordered_product: @attributes
      expect(cookies.signed[:customer_token]).not_to eq(@wrong_cookie)
    end

    it 'If right cookie present - must not be changed' do
      post :create, product_id: @product, ordered_product: @attributes
      @gotten_cookie = cookies.signed[:customer_token]
      post :create, product_id: @product, ordered_product: @attributes
      expect(cookies.signed[:customer_token]).to eq(@gotten_cookie)
    end
  end

  #--------------------------------- Edit ------------------------------------

  describe 'Edit: ' do
    it "User must get access if order belongs to user and 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_opened_order
      get :edit, id: @product_in_opened_order
      expect(response).to render_template 'edit'
    end

    it "User must not get access if order doesn't belong to user" do
      cookies.signed[:customer_token] = @wrong_cookie
      get :edit, id: @product_in_opened_order
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it "User must not get access if order are not 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_not_opened_order
      get :edit, id: @product_in_not_opened_order
      expect(assigns(:ordered_product).order.status).not_to eq('opened')
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it "If product doesn't not exist" do
      cookies.signed[:customer_token] = @cookie_for_opened_order
      get :edit, id: @no_existing_product
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end
  end

  #---------------------------------- Update ---------------------------------

  describe 'Update: ' do
    it "User must get access if order belongs to user and 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_opened_order
      patch :update, id: @product_in_opened_order,
                     ordered_product: @attributes
      @path = order_ordered_products_path(assigns(:ordered_product).order)
      expect(response).to redirect_to @path
      expect(flash[:message]).to eq(I18n.t(:product_has_been_updated))
    end

    it "User must not get access if order doesn't belong to user" do
      cookies.signed[:customer_token] = @wrong_cookie
      patch :update, id: @product_in_opened_order,
                     ordered_product: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it "User must not get access if order are not 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_not_opened_order
      patch :update, id: @product_in_not_opened_order,
                     ordered_product: @attributes
      expect(assigns(:ordered_product).order.status).not_to eq('opened')
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it "If product doesn't not exist" do
      cookies.signed[:customer_token] = @cookie_for_opened_order
      patch :update, id: @no_existing_product,
                     ordered_product: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end
  end

  #-------------------------------- Destroy ----------------------------------

  describe 'Destroy: ' do
    it "User must get access if order belongs to user and 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_opened_order
      delete :destroy, id: @product_in_opened_order
      @path = order_ordered_products_path(assigns(:ordered_product).order)
      expect(response).to redirect_to @path
      expect(flash[:message]).to eq(I18n.t(:product_has_been_deleted))
    end

    it "User must not get access if order doesn't belong to user" do
      cookies.signed[:customer_token] = @wrong_cookie
      delete :destroy, id: @product_in_opened_order
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it "User must not get access if order are not 'opened'" do
      cookies.signed[:customer_token] = @cookie_for_not_opened_order
      delete :destroy, id: @product_in_not_opened_order
      expect(assigns(:ordered_product).order.status).not_to eq('opened')
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it "If product doesn't not exist" do
      cookies.signed[:customer_token] = @cookie_for_opened_order
      delete :destroy, id: @no_existing_product
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end
  end

  #----------------------------------- Index ---------------------------------

  describe 'Index: ' do
    context "Users must get access to basket ('opened' order)" do
      after(:each) do
        cookies.signed[:customer_token] = @cookie_for_opened_order
        get :index, order_id: @opened_order
        expect(assigns(:order).status).to eq('opened')
        expect(response).to render_template 'basket'
      end

      it 'Anonymous if order belongs to them' do
      end

      it 'Customer' do
        sign_in Users(:customer)
      end

      it 'Manager' do
        sign_in Users(:manager)
      end

      it 'Admin' do
        sign_in Users(:admin)
      end
    end

    context "Admin and manager must get access to customers 'opened' order" do
      it 'Manager for view' do
        sign_in Users(:manager)
        get :index, order_id: @opened_order
        expect(assigns(:order).status).to eq('opened')
        expect(response).to render_template 'index'
      end

      it 'Admin for view' do
        sign_in Users(:admin)
        get :index, order_id: @opened_order
        expect(assigns(:order).status).to eq('opened')
        expect(response).to render_template 'index'
      end
    end

    context "Users must not get access to basket ('opened' order)" do
      it "Anonymous if order doesn't belong to them" do
        cookies.signed[:customer_token] = @wrong_cookie
        get :index, order_id: @opened_order
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
      end

      it "Logged in users if order desn't belong to them" do
        sign_in Users(:customer)
        cookies.signed[:customer_token] = @wrong_cookie
        get :index, order_id: @opened_order
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
      end
    end

    context "Users must get access to history (not 'opened' order): " do
      it 'Logged in customers if order belongs to them' do
        sign_in Users(:customer)
        get :index, order_id: @not_opened_customer_order
        expect(response).to render_template 'index'
      end

      it 'Manager to any orders' do
        sign_in Users(:manager)
        get :index, order_id: @not_opened_customer_order
        expect(response).to render_template 'index'
      end

      it 'Admin to any orders' do
        sign_in Users(:admin)
        get :index, order_id: @not_opened_customer_order
        expect(response).to render_template 'index'
      end
    end

    context "Users must not get access to history (not 'opened' order): " do
      it 'Anonymous' do
        cookies.signed[:customer_token] = @cookie_for_not_opened_order
        get :index, order_id: @not_opened_order
        expect(assigns(:order).status).not_to eq('opened')
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
      end

      it "Logged in customers if order doesn't belong to them" do
        sign_in Users(:customer)
        cookies.signed[:customer_token] = @cookie_for_not_opened_order
        get :index, order_id: @not_opened_order
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
      end
    end

    context "If order doesn't not exist user must be redirected: " do
      it 'Anonymous user' do
        cookies.signed[:customer_token] = @cookie_for_opened_order
        get :index, order_id: @no_existing_order
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
      end

      it 'Logged in user' do
        sign_in Users(:customer)
        get :index, order_id: @no_existing_order
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
      end
    end
  end

  #---------------------------------- ****** ---------------------------------
end
