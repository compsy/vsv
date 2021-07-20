# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post '/informed_consent' => 'questionnaire#create_informed_consent'
  get '/klaar' => 'reward#index'
  post '/' => 'questionnaire#create'
  root to: 'token_authentication#show'
  resources :mentor_overview, only: [:index]
  resources :questionnaire, only: %i[index show create destroy], param: :uuid do
    collection do
      get 'preference/:uuid', to: 'questionnaire#preference', as: 'preference'
      get :interactive
      post :interactive_render
      post :from_json
    end
  end
  resource :person, only: %i[edit update] do
    get 'unsubscribe'
  end

  get 'o', to: 'one_time_response#show', as: 'one_time_response'

  # Admin panel
  scope path: :admin do
    get '/', to: 'admin#index', as: 'admin'
    get 'export', to: 'admin#export', as: 'admin_export'
    get 'preview_overview', to: 'admin#preview_overview', as: 'admin_preview_overview'
    get 'organization_overview', to: 'admin#organization_overview', as: 'admin_organization_overview'

    get 'person_export', to: 'admin#person_export', as: 'admin_person_export'
    get 'identifier_export', to: 'admin#identifier_export', as: 'admin_identifier_export'
    get 'protocol_subscription_export', to: 'admin#protocol_subscription_export', as: 'admin_protocol_subscription_export'
    get 'invitation_set_export', to: 'admin#invitation_set_export', as: 'admin_invitation_set_export'
    get 'protocol_transfer_export', to: 'admin#protocol_transfer_export', as: 'admin_protocol_transfer_export'
    get 'questionnaire_export/:id', to: 'admin#questionnaire_export', as: 'admin_questionnaire_export'
    get 'response_export/:id', to: 'admin#response_export', as: 'admin_response_export'
    get 'reward_export', to: 'admin#reward_export', as: 'admin_reward_export'
    get 'proof_of_participation_export', to: 'admin#proof_of_participation_export', as: 'admin_proof_of_participation_export'

    post 'preview', to: 'admin#preview', as: 'admin_preview'
    get 'preview', to: 'admin#preview', as: 'admin_preview_get'
    post 'preview_done', to: 'admin#preview_done', as: 'admin_preview_done'
    get '*path', to: 'admin#index'
  end

  # Static pages
  get 'disclaimer', to: 'static_pages#disclaimer', as: 'disclaimer'

  # Status
  get '/status' => 'status#show'

  namespace :api do
    namespace :v1 do


      # JWT APIs
      scope module: :jwt_api do
        resources :one_time_response, only: [:index, :show], param: :otr
        resources :questionnaire, only: [:index, :show, :create], param: :key do
          resources :results, only: [] do
            collection do
              get :distribution
            end
          end
        end
        resources :response, only: [:show, :index, :create], param: :uuid do
          collection do
            get :completed
            get :all
          end
        end
        resources :auth_user, only: [:create]
        resources :people, only: [:create] do
          collection do
            get :list_children
          end
          member do
            put :update_child
            delete :destroy_child
          end
        end

        resources :protocol_subscriptions, only: [] do
          collection do
            # @note Watch out! This can be interpreted as a show route later.
            get :mine # just retrieves active protocol subscriptions that are filled out "for myself"
            get :my_active_and_inactive
          end
        end
        resources :protocol, only: [:index]
      end

      # JWT and Cookie apis
      # TODO in V2 API, rename to people.
      scope module: :cookie_and_jwt_api do
        resources :protocol_subscriptions, only: [:create, :show, :destroy]

        resources :person, only: [] do
          collection do
            get :me
            get :my_students
            put :update
            delete :destroy
          end
        end
      end

      # Basic auth APIs
      namespace :basic_auth_api do
        resources :scheduling, only: [] do
          collection do
            post :daily_at_one_am
            post :daily_at_two_am
            post :daily_at_three_am
            post :daily_at_four_am
            post :daily
            post :hourly
            post :thirty_minutely
            post :five_minutely
            post :minutely
          end
        end

        resources :protocol_subscriptions, only: [:create, :destroy, :update] do
          collection do
            get :delegated_protocol_subscriptions
            delete :destroy_delegated_protocol_subscriptions
          end
        end
        resources :person, only: [] do
          collection do
            get :show_list
          end
          member do
            post :change_to_mentor
          end
        end

        resources :questionnaires, only: [:create]
      end

      # Admin APIs
      namespace :admin do
        resources :team, only: [:show], param: :group
        resources :organization, only: [:show], param: :group
      end

      # Public APIs
      resources :statistics, only: [:index]
      resources :settings, only: [:index]
    end
  end
  match '/',
        controller: 'application',
        action: 'options',
        constraints: { method: %w[OPTIONS POST PUT PATCH DELETE] },
        via: %i[options post put patch delete]
  match '*path', via: :all, to: 'application#page_not_found'
end
