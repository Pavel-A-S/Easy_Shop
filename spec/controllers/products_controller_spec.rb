require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  fixtures :Users, :Products

  before(:each) do
    @attributes = { name: 'Test_Product',
                    description: 'Test',
                    category_id: 'none',
                    count: '1',
                    price: '2',
                    photo: 'none' }
    @product = 96
    @no_existing_product = 69
  end

  #------------------------------------ New ----------------------------------

  describe 'New: ' do
    it 'Unauthorized user must not get access' do
      get :new
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      get :new
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it 'Manager must get access' do
      sign_in Users(:manager)
      get :new
      expect(response).to render_template 'new'
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      get :new
      expect(response).to render_template 'new'
    end
  end

  #---------------------------------- Create ---------------------------------

  describe 'Create: ' do
    it 'Unauthorized user must not get access' do
      post :create, product: @attributes
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      post :create, product: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it 'Manager must get access' do
      sign_in Users(:manager)
      post :create, product: @attributes
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:product_has_been_added))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      post :create, product: @attributes
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:product_has_been_added))
    end
  end

  #----------------------------------- Edit ----------------------------------

  describe 'Edit: ' do
    it 'Unauthorized user must not get access' do
      get :edit, id: @product
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      get :edit, id: @product
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it 'Manager must get access' do
      sign_in Users(:manager)
      get :edit, id: @product
      expect(response).to render_template 'edit'
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      get :edit, id: @product
      expect(response).to render_template 'edit'
    end
  end

  #---------------------------------- Update ---------------------------------

  describe 'Update: ' do
    it 'Unauthorized user must not get access' do
      patch :update, id: @product, product: @attributes
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      patch :update, id: @product, product: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it "Must be redirected if order doesn't exist" do
      sign_in Users(:admin)
      patch :update, id: @no_existing_product, product: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_existence_problem))
    end

    it 'Manager must get access' do
      sign_in Users(:manager)
      patch :update, id: @product, product: @attributes
      expect(response).to redirect_to product_path(@product)
      expect(flash[:message]).to eq(I18n.t(:product_has_been_updated))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      patch :update, id: @product, product: @attributes
      expect(response).to redirect_to product_path(@product)
      expect(flash[:message]).to eq(I18n.t(:product_has_been_updated))
    end
  end

  #--------------------------------- Destroy ---------------------------------

  describe 'Destroy: ' do
    it 'Unauthorized user must not get access' do
      delete :destroy, id: @product
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      delete :destroy, id: @product
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_operation_problem))
    end

    it "Must be redirected if order doesn't exist" do
      sign_in Users(:admin)
      delete :destroy, id: @no_existing_product
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_existence_problem))
    end

    it 'Manager must get access' do
      sign_in Users(:manager)
      delete :destroy, id: @product
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:product_has_been_deleted))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      delete :destroy, id: @product
      expect(response).to redirect_to products_path
      expect(flash[:message]).to eq(I18n.t(:product_has_been_deleted))
    end
  end

  #----------------------------------- Index ---------------------------------

  describe 'Index: ' do
    after(:each) do
      get :index
      expect(response).to render_template 'index'
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

  #------------------------------------ Show ---------------------------------

  describe 'Show: ' do
    it "Must be redirected if order doesn't exist" do
      get :show, id: @no_existing_product
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:product_existence_problem))
    end

    context 'Must get access' do
      after(:each) do
        get :show, id: @product
        expect(response).to render_template 'show'
      end

      it 'Unauthorized users' do
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

  #---------------------------------- ****** ---------------------------------
end
