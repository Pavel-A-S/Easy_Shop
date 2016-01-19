Rails.application.routes.draw do
  devise_for :users
  root 'navigation#home'

  get 'basket', to: 'navigation#basket', as: 'basket'
  get 'choice', to: 'navigation#choice', as: 'choice'

  resources :access, only: [:index, :show, :destroy, :edit, :update]

  resources :main_photos, only: [:destroy]

  resources :main_descriptions, except: [:index] do
    resources :main_photos, only: [:new, :create]
  end

  resources :categories

  resources :ordered_products, except: [:create, :index]

  resources :products do
    resources :ordered_products, only: [:create]
  end

  resources :orders, only: [:show, :index, :edit, :update, :destroy] do
    resources :ordered_products, only: [:index]
    get 'fill', on: :new
    patch 'processing', on: :collection
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions
  # automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
