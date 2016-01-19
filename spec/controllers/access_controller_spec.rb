require 'rails_helper'

RSpec.describe AccessController, type: :controller do
  fixtures :Users

  before(:all) do
    @user = 1
    @customer = 1
    @manager = 2
    @admin = 3
    @no_existing_user = 69

    @admin_attributes = { name: 'New_customer',
                          phone: '12345678',
                          status: 'customer' }

    @attributes = { name: 'New_customer',
                    phone: '12345678' }
  end

  #---------------------------------- Show -----------------------------------

  describe 'Show: ' do
    it 'Unauthorized user must not get access' do
      get :show, id: @user
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must get access to his own profile only' do
      sign_in Users(:customer)
      get :show, id: @user
      expect(response).to render_template 'show'
      get :show, id: @manager
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end

    it 'Manager must get access to his own profile only' do
      sign_in Users(:manager)
      get :show, id: @manager
      expect(response).to render_template 'show'
      get :show, id: @user
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end

    it 'Admin must get access to any profile' do
      sign_in Users(:admin)
      get :show, id: @admin
      expect(response).to render_template 'show'
      get :show, id: @user
      expect(response).to render_template 'show'
      get :show, id: @manager
      expect(response).to render_template 'show'
    end

    it "Must be redirected if user doesn't exist" do
      sign_in Users(:admin)
      get :show, id: @no_existing_user
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end
  end

  #---------------------------------- Edit -----------------------------------

  describe 'Edit: ' do
    it 'Unauthorized user must not get access' do
      get :edit, id: @user
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must get access to his own profile only' do
      sign_in Users(:customer)
      get :edit, id: @user
      expect(response).to render_template 'edit'
      get :edit, id: @manager
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end

    it 'Manager must get access to his own profile only' do
      sign_in Users(:manager)
      get :edit, id: @manager
      expect(response).to render_template 'edit'
      get :edit, id: @user
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end

    it 'Admin must get access to any profile' do
      sign_in Users(:admin)
      get :edit, id: @admin
      expect(response).to render_template 'edit'
      get :edit, id: @user
      expect(response).to render_template 'edit'
      get :edit, id: @manager
      expect(response).to render_template 'edit'
    end

    it "Must be redirected if user doesn't exist" do
      sign_in Users(:admin)
      get :edit, id: @no_existing_user
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end
  end

  #-------------------------------- Update -----------------------------------

  describe 'Update: ' do
    it 'Unauthorized user must not get access' do
      patch :update, id: @customer, user: @attributes
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must get access to his own profile only' do
      sign_in Users(:customer)
      patch :update, id: @customer, user: @attributes
      expect(response).to redirect_to access_path(@customer)
      expect(flash[:message]).to eq(I18n.t(:user_has_been_updated))
      patch :update, id: @manager, user: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end

    it 'Manager must get access to his own profile only' do
      sign_in Users(:manager)
      patch :update, id: @manager, user: @attributes
      expect(response).to redirect_to access_path(@manager)
      expect(flash[:message]).to eq(I18n.t(:user_has_been_updated))
      patch :update, id: @customer, user: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end

    it 'Admin must get access to any profile' do
      sign_in Users(:admin)
      patch :update, id: @admin, user: @attributes
      expect(response).to redirect_to access_path(@admin)
      expect(flash[:message]).to eq(I18n.t(:user_has_been_updated))

      patch :update, id: @customer, user: @attributes
      expect(response).to redirect_to access_path(@customer)
      expect(flash[:message]).to eq(I18n.t(:user_has_been_updated))

      patch :update, id: @manager, user: @admin_attributes
      expect(response).to redirect_to access_path(@manager)
      expect(flash[:message]).to eq(I18n.t(:user_has_been_updated))
    end

    it "Any user must be redirected if user profile doesn't exist" do
      sign_in Users(:admin)
      patch :update, id: @no_existing_user, user: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end

    context 'Must not update profile with admin attributes' do
      it 'Manager' do
        sign_in Users(:manager)
        patch :update, id: @manager, user: @admin_attributes
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:operation_problem))
      end

      it 'Customer' do
        sign_in Users(:customer)
        patch :update, id: @customer, user: @admin_attributes
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq(I18n.t(:operation_problem))
      end
    end
  end

  #------------------------------- Destroy -----------------------------------

  describe 'Destroy: ' do
    it 'Unauthorized user must not get access' do
      delete :destroy, id: @user
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      delete :destroy, id: @user
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      delete :destroy, id: @user
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      delete :destroy, id: @user
      expect(response).to redirect_to access_index_path
      expect(flash[:message]).to eq(I18n.t(:user_has_been_deleted))
    end

    it "Admin must be redirected if user doesn't exist" do
      sign_in Users(:admin)
      delete :destroy, id: @no_existing_user
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:user_existence_problem))
    end
  end

  #--------------------------------- Index -----------------------------------

  describe 'Index: ' do
    it 'Unauthorized user must not get access' do
      get :index
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      get :index
      expect(response).to render_template 'index'
    end
  end

  #-------------------------------- ****** -----------------------------------
end
