require 'rails_helper'

RSpec.describe MainPhotosController, type: :controller do
  fixtures :Users, :MainDescriptions, :MainPhotos

  before(:each) do
    @main_photo = 1
    @photo = { photo: [fixture_file_upload('files/photo.gif')] }
    @no_photo = {}
    @main_description = 3
    @no_existing_main_description = 69
    @no_existing_photo = 69
  end

  #---------------------------------- New ------------------------------------

  describe 'New: ' do
    it 'Unauthorized user must not get access' do
      get :new, main_description_id: @main_description
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      get :new, main_description_id: @main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      get :new, main_description_id: @main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      get :new, main_description_id: @main_description
      expect(response).to render_template 'new'
    end

    it 'Admin must be redirected if description ID is wrong' do
      sign_in Users(:admin)
      get :new, main_description_id: @no_existing_main_description
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:description_existence_problem))
    end
  end

  #-------------------------------- Create -----------------------------------

  describe 'Create: ' do
    it 'Unauthorized user must not get access' do
      post :create, main_description_id: @main_description,
                    main_photo: @photo
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      post :create, main_description_id: @main_description,
                    main_photo: @photo
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      post :create, main_description_id: @main_description,
                    main_photo: @photo
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      post :create, main_description_id: @main_description,
                    main_photo: @photo
      expect(assigns(:main_description).main_photos.empty?).to eq(false)
      expect(response).to redirect_to root_path
      expect(flash[:message]).to eq(I18n.t(:photo_has_been_added))
    end

    it 'Admin must get an error if data is wrong' do
      sign_in Users(:admin)
      post :create, main_description_id: @main_description,
                    main_photo: @no_photo
      expect(assigns(:main_description).main_photos.empty?).to eq(true)
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:photo_data_problem))
    end

    it 'Admin must be redirected if description ID is wrong' do
      sign_in Users(:admin)
      post :create, main_description_id: @no_existing_main_description,
                    main_photo: @photo
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:description_existence_problem))
    end
  end

  #------------------------------- Destroy -----------------------------------

  describe 'Destroy: ' do
    it 'Unauthorized user must not get access' do
      delete :destroy, id: @main_photo
      expect(response).to redirect_to new_user_session_path
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
    end

    it 'Customer must not get access' do
      sign_in Users(:customer)
      delete :destroy, id: @main_photo
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Manager must not get access' do
      sign_in Users(:manager)
      delete :destroy, id: @main_photo
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:operation_problem))
    end

    it 'Admin must get access' do
      sign_in Users(:admin)
      delete :destroy, id: @main_photo
      expect(response).to redirect_to root_path
      expect(flash[:message]).to eq(I18n.t(:photo_has_been_deleted))
    end

    it "Admin must be redirected if photo doesn't exist" do
      sign_in Users(:admin)
      delete :destroy, id: @no_existing_photo
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq(I18n.t(:photo_existence_problem))
    end
  end

  #-------------------------------- ****** -----------------------------------
end
