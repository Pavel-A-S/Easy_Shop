require 'rails_helper'

RSpec.describe MainDescriptionsController, type: :controller do
  fixtures :Users, :MainDescriptions

  before(:each) do
    @main_description = 3
    @no_existing_main_description = 69

    @attributes = { title: 'Title for test',
                    description: 'Description for test' }
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

  #--------------------------------- Edit ------------------------------------

  describe 'Edit: ' do
    it 'Unauthorized user must not get access' do
      get :edit, id: @main_description
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      get :edit, id: @main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      get :edit, id: @main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      get :edit, id: @main_description
      expect(response).to render_template 'edit'
    end

    it 'Admin must be redirected if description ID is wrong' do
      sign_in Users(:admin)
      get :edit, id: @no_existing_main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:description_existence_problem))
    end
  end

  #--------------------------------- Destroy ---------------------------------

  describe 'Destroy: ' do
    it 'Unauthorized user must not get access' do
      delete :destroy, id: @main_description
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      delete :destroy, id: @main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      delete :destroy, id: @main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      delete :destroy, id: @main_description
      expect(response).to redirect_to root_path
      expect(flash[:message]).to eq(I18n.t(:description_has_been_deleted))
    end

    it "Admin must be redirected if description doesn't exist" do
      sign_in Users(:admin)
      delete :destroy, id: @no_existing_main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:description_existence_problem))
    end
  end

  #-------------------------------- Create -----------------------------------

  describe 'Create: ' do
    it 'Unauthorized user must not get access' do
      post :create, main_description: @attributes
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      post :create, main_description: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      post :create, main_description: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      post :create, main_description: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:message]).to eq(I18n.t(:description_has_been_added))
    end
  end

  #---------------------------------- Update ---------------------------------

  describe 'Update: ' do
    it 'Unauthorized user must not get access' do
      patch :update, id: @main_description, main_description: @attributes
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      patch :update, id: @main_description, main_description: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      patch :update, id: @main_description, main_description: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      patch :update, id: @main_description, main_description: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:message]).to eq(I18n.t(:description_has_been_updated))
    end

    it "Admin must be redirected if description doesn't exist" do
      sign_in Users(:admin)
      patch :update, id: @no_existing_main_description,
                     main_description: @attributes
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:description_existence_problem))
    end
  end

  #-------------------------------- ****** -----------------------------------
end
