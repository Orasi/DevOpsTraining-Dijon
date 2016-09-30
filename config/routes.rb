Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#dashboard'
  post 'login', to: 'application#login', as: :login
  get 'login', to: 'application#login_page'
  get 'logout', to: 'application#logout', as: :logout
  get 'dashboard', to: 'welcome#dashboard', as: :dashboard

  resources :projects
  resources :testcases
  resources :teams
  resources :users
  resources :environments
  resources :executions
  get 'executions/:id/testcase_detail/:testcase_id', to: 'executions#testcase_detail', as: :testcase_detail
  resources :results
end
