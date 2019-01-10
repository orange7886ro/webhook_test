Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :webhooks, only: [] do
    collection do
      post :usecase_test
    end
  end
end
