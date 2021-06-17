require "./lib/api/version"

Rails.application.routes.draw do
  if !Rails.env.production?
    # Swagger UI
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    scope module: :v1, constraints: ApiVersion.new('v1', true) do
      concern :with_disbursements do
        member do
          get :disbursements, to: 'disbursements#show'
        end

        collection do
          get :disbursements, to: 'disbursements#index'
        end
      end

      resources :merchants, concerns: :with_disbursements, only: [:disbursements]
    end
  end
end
