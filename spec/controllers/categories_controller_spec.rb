require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  fixtures :Users, :Categories

  before(:all) do
    @first_attributes = { name: 'Parent category',
                          category_id: 1,
                          category_type: 'Section name' }

    @for_search_attributes = { name: 'Ending category',
                               category_type: 'For search' }

    @wrong_parent_type_attributes = { name: 'Wrong parent type',
                                      category_id: 2,
                                      category_type: 'For search' }

    @wrong_type_attributes = { name: 'Wrong type',
                               category_id: 1,
                               category_type: 'Wrong type' }

    @wrong_parent_attributes = { name: 'Wrong category',
                                 category_id: 69,
                                 category_type: 'For search' }

    @first_category = 1

    @endpoint_category = 2

    @second_endpoint_category = 3

    @no_existing_category = 69
  end

  #---------------------------------- New ------------------------------------

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
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      get :new
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      get :new
      expect(response).to render_template 'new'
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

  #-------------------------------- Create -----------------------------------

  describe 'Create: ' do
    it 'Unauthorized user must not get access' do
      post :create, category: @first_attributes
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      post :create, category: @first_attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      post :create, category: @first_attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      post :create, category: @first_attributes
      expect(response).to redirect_to categories_path
      expect(flash[:message]).to eq(I18n.t(:category_has_been_created))
    end

    it 'if wrong parent category - Admin must get message' do
      sign_in Users(:admin)
      post :create, category: @wrong_parent_attributes
      expect(response).to render_template 'new'
      expect(flash.now[:alert]).to eq(I18n.t(:category_parent_problem))
    end

    it 'if wrong parent category type - Admin must get message' do
      sign_in Users(:admin)
      post :create, category: @wrong_parent_type_attributes
      expect(response).to render_template 'new'
      expect(flash.now[:alert]).to eq(I18n.t(:category_parent_type_problem))
    end

    it 'if wrong category type - Admin must get message' do
      sign_in Users(:admin)
      post :create, category: @wrong_type_attributes
      expect(response).to render_template 'new'
      expect(flash.now[:alert]).to eq(I18n.t(:category_type_problem))
    end
  end

  #--------------------------------- Edit ------------------------------------

  describe 'Edit: ' do
    it 'Unauthorized user must not get access' do
      get :edit, id: @endpoint_category
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      get :edit, id: @endpoint_category
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      get :edit, id: @endpoint_category
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      get :edit, id: @endpoint_category
      expect(response).to render_template 'edit'
    end

    it 'Admin must be redirected if category ID is wrong' do
      sign_in Users(:admin)
      get :edit, id: @no_existing_category
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:category_existence_problem))
    end
  end

  #---------------------------------- Update ---------------------------------

  describe 'Update: ' do
    it 'Unauthorized user must not get access' do
      patch :update, id: @endpoint_category, category: @first_attributes
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      patch :update, id: @endpoint_category, category: @first_attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      patch :update, id: @endpoint_category, category: @first_attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      patch :update, id: @endpoint_category, category: @first_attributes
      expect(response).to redirect_to categories_path
      expect(flash[:message]).to eq(I18n.t(:category_has_been_updated))
    end

    it "Admin must be redirected if category doesn't exist" do
      sign_in Users(:admin)
      patch :update, id: @no_existing_category, category: @first_attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:category_existence_problem))
    end

    it 'if parent category id is present and wrong - Admin must get message' do
      sign_in Users(:admin)
      patch :update, id: @endpoint_category,
                     category: @wrong_parent_attributes
      expect(response).to redirect_to root_path
      expect(flash.now[:alert]).to eq(I18n.t(:category_parent_problem))
    end

    it 'if category id and parent category id are same - must get message' do
      sign_in Users(:admin)
      patch :update, id: @first_category,
                     category: @first_attributes
      expect(response).to redirect_to root_path
      expect(flash.now[:alert]).to eq(I18n.t(:category_parent_problem))
    end

    it "if parent category type is 'For search' - must get message" do
      sign_in Users(:admin)
      patch :update, id: @second_endpoint_category,
                     category: @wrong_parent_type_attributes
      expect(response).to render_template 'edit'
      expect(flash.now[:alert]).to eq(I18n.t(:category_parent_type_problem))
    end

    it "if category has children and type is 'For search' - must get message" do
      sign_in Users(:admin)
      patch :update, id: @first_category,
                     category: @for_search_attributes
      expect(response).to render_template 'edit'
      expect(flash.now[:alert]).to eq(I18n.t(:category_has_subcategory))
    end

    it 'if category has wrong type - must get message' do
      sign_in Users(:admin)
      patch :update, id: @second_endpoint_category,
                     category: @wrong_type_attributes
      expect(response).to redirect_to root_path
      expect(flash.now[:alert]).to eq(I18n.t(:category_type_problem))
    end
  end

  #------------------------------- Destroy -----------------------------------

  describe 'Destroy: ' do
    it 'Unauthorized user must not get access' do
      delete :destroy, id: @first_category
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      delete :destroy, id: @first_category
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      delete :destroy, id: @first_category
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      delete :destroy, id: @first_category
      expect(response).to redirect_to categories_path
      expect(flash[:message]).to eq(I18n.t(:category_has_been_deleted))
    end

    it "Admin must be redirected if category doesn't exist" do
      sign_in Users(:admin)
      delete :destroy, id: @no_existing_category
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:category_existence_problem))
    end
  end

  #---------------------------------- ****** ---------------------------------
end
