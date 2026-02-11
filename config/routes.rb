Rails.application.routes.draw do
  resources :borrowings
  resources :users
  resources :books do
      member do
        post :borrow
        post :return_book
      end
    end
end
