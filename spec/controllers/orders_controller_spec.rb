require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  fixtures :Users, :Orders

  def customer_attributes(object)
    {
      customer_name: object.customer_name,
      phone: object.phone,
      email: object.email,
      description: object.description }
  end

  def manager_attributes(object)
    {
      status_description: object.status_description,
      status: object.status }
  end

  before(:all) do
    @customer_order = 3
    @not_customer_order = 4

    @customer_awaited_order = 5
    @not_customer_awaited_order = 6
    @customer_not_awaited_order = 7
    @no_existing_order = 69

    @admin_attributes = { customer_name: 'Customer',
                          phone: '12345678',
                          email: 'test@test.com',
                          description: 'It is just test and nothing more',
                          status_description: 'Status description test',
                          status: 'opened' }

    @customer_attributes = { customer_name: 'Customer',
                             phone: '12345678',
                             email: 'test@test.com',
                             description: 'It is just test and nothing more' }

    @manager_attributes = { status_description: 'Status description test',
                            status: 'opened' }
  end

  #-------------------------------- Index ------------------------------------

  describe 'Index: ' do
    it 'Unauthorized user must not get access' do
      get :index
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must get access to customer_index template' do
      sign_in Users(:customer)
      get :index
      expect(response).to render_template 'customer_index'
    end

    it 'Manager must get access to manager_index template' do
      sign_in Users(:manager)
      get :index
      expect(response).to render_template 'manager_index'
    end

    it 'Admin must get access to index template' do
      sign_in Users(:admin)
      get :index
      expect(response).to render_template 'index'
    end
  end

  #--------------------------------- Fill ------------------------------------

  describe 'Fill: ' do
    context "Any user must get access if he has 'opened' order: " do
      before(:each) { cookies.signed[:customer_token] = 'opened_order' }

      after(:each) do
        get :fill
        expect(response).to render_template 'fill'
      end

      it 'Anonymous' do
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

    context "Any user must not get access if order isn't opened: " do
      before(:each) { cookies.signed[:customer_token] = 'not_opened_order' }

      after(:each) do
        get :fill
        expect(response).to redirect_to products_path
        expect(flash[:alert]).to eq(I18n.t(:basket_is_empty))
      end

      it 'Anonymous' do
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
  end

  #------------------------------- Show --------------------------------------

  describe 'Show: ' do
    it 'Anonymous must not get access' do
      get :show, id: @customer_order
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access to another persons order' do
      sign_in Users(:customer)
      get :show, id: @not_customer_order
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:order_existence_problem))
    end

    it "If order doesn't exist - customer must be redirected" do
      sign_in Users(:customer)
      get :show, id: @no_existing_order
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:order_existence_problem))
    end

    context 'Users must get access if have permission: ' do
      after(:each) do
        get :show, id: @customer_order
        expect(response).to render_template 'show'
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
  end

  #-------------------------------- Edit ---------------------------------------

  describe 'Edit: ' do
    it 'Anonymous must not get access to any orders' do
      get :edit, id: @customer_awaited_order
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it "Customer must not get access to not 'awaited' orders" do
      sign_in Users(:customer)
      get :edit, id: @customer_not_awaited_order
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:order_change_problem))
    end

    it 'Customer must not get access to another persons order' do
      sign_in Users(:customer)
      get :edit, id: @not_customer_awaited_order
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:order_change_problem))
    end

    it "If order doesn't exist - customer must be redirected" do
      sign_in Users(:customer)
      get :edit, id: @no_existing_order
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:order_existence_problem))
    end

    context 'Users must get access if have permission: ' do
      it 'Customer' do
        sign_in Users(:customer)
        get :edit, id: @customer_awaited_order
        expect(response).to render_template 'customer_edit'
      end

      it 'Manager' do
        sign_in Users(:manager)
        get :edit, id: @customer_awaited_order
        expect(response).to render_template 'manager_edit'
      end

      it 'Admin' do
        sign_in Users(:admin)
        get :edit, id: @customer_awaited_order
        expect(response).to render_template 'edit'
      end
    end
  end

  #--------------------------------- Update ------------------------------------

  describe 'Update: ' do
    it 'Anonymous must not get access to any orders' do
      patch :update, id: @customer_awaited_order,
                     order: @customer_attributes
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access to another persons order' do
      sign_in Users(:customer)
      patch :update, id: @not_customer_awaited_order,
                     order: @customer_attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:who_are_you))
    end

    it "Customer must not get access to not 'awaited' orders" do
      sign_in Users(:customer)
      patch :update, id: @customer_not_awaited_order,
                     order: @customer_attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:who_are_you))
    end

    it "Users must be redirected if order doesn't exist" do
      sign_in Users(:admin)
      patch :update, id: @no_existing_order,
                     order: @customer_attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:order_change_problem))
    end

    it 'Customer must not update orders with manager or admin attributes' do
      sign_in Users(:customer)
      @attributes = manager_attributes(Orders(:customer_awaited_order))
      patch :update, id: @customer_awaited_order,
                     order: @admin_attributes
      expect(manager_attributes(assigns(:order))).to eq(@attributes)
    end

    it 'Manager must not update orders with customer attributes' do
      sign_in Users(:manager)
      @attributes = customer_attributes(Orders(:customer_awaited_order))
      patch :update, id: @customer_awaited_order,
                     order: @customer_attributes
      expect(customer_attributes(assigns(:order))).to eq(@attributes)
    end

    context 'Users must get access if have permission: ' do
      after(:each) do
        expect(response).to redirect_to orders_path
        expect(flash[:message]).to eq(I18n.t(:order_has_been_updated,
                                             order_name: assigns(:order)
                                                         .order_name))
      end

      it 'Customer' do
        sign_in Users(:customer)
        patch :update, id: @customer_awaited_order,
                       order: @customer_attributes
      end

      it 'Manager' do
        sign_in Users(:manager)
        patch :update, id: @customer_not_awaited_order,
                       order: @manager_attributes
      end

      it 'Admin' do
        sign_in Users(:admin)
        patch :update, id: @customer_not_awaited_order,
                       order: @admin_attributes
      end
    end
  end

  #------------------------------- Processing ----------------------------------

  describe 'Processing: ' do
    it 'Customer must not change orders with manager or admin attributes' do
      cookies.signed[:customer_token] = 'opened_order'
      patch :processing, order: @manager_attributes
      expect(manager_attributes(assigns(:order))).not_to eq(@manager_attributes)
    end

    context "Any user must get access if he has 'opened' order: " do
      before(:each) { cookies.signed[:customer_token] = 'opened_order' }

      after(:each) do
        patch :processing, order: @customer_attributes
        expect(flash[:message]).to eq(I18n.t(:order_has_been_created,
                                             order_name: assigns(:order)
                                                         .order_name))

        expect(response).to redirect_to root_path
      end

      it 'Anonymous' do
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

    context "Any user must not get access if order isn't opened: " do
      before(:each) { cookies.signed[:customer_token] = 'not_opened_order' }

      after(:each) do
        patch :processing, order: @customer_attributes
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:order_existence_problem))
      end

      it 'Anonymous' do
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
  end

  #--------------------------------- Destroy -----------------------------------

  describe 'Destroy: ' do
    it 'Admin must get access' do
      sign_in Users(:admin)
      delete :destroy, id: @customer_awaited_order
      expect(response).to redirect_to orders_path
      expect(flash[:message]).to eq(I18n.t(:order_has_been_deleted,
                                           order_name: assigns(:order)
                                                       .order_name))
    end

    it "Redirect if order doesn't exist" do
      sign_in Users(:admin)
      delete :destroy, id: @no_existing_order
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:order_existence_problem))
    end

    context 'Users must not get access: ' do
      it 'Anonymous' do
        delete :destroy, id: @customer_awaited_order
        expect(response).to redirect_to new_user_session_path
        expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      end

      it 'Customer' do
        sign_in Users(:customer)
        delete :destroy, id: @customer_awaited_order
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:who_are_you))
      end

      it 'Manager' do
        sign_in Users(:manager)
        delete :destroy, id: @customer_awaited_order
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:who_are_you))
      end
    end
  end

  #--------------------------------- ****** ------------------------------------
end
