Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  # App Paths
  root 'welcome#dashboard'
  post 'login', to: 'application#login', as: :login
  get 'login', to: 'application#login_page'
  get 'logout', to: 'application#logout', as: :logout
  get 'dashboard', to: 'welcome#dashboard', as: :dashboard


  #Project Paths
  resources :projects


  # Teastcase Paths
  resources :testcases
  get 'projects/:id/testcases/import', to: 'testcases#import_form', as: :testcase_import
  post 'projects/:id/testcases/import(/:preview)', to: 'testcases#import'


  #Team Paths
  resources :teams
  post 'teams/:id/projects/users', to: 'teams#add_project', as: :team_project
  delete 'teams/:id/projects/:project_id', to: 'teams#remove_project', as: :remove_team_project
  post 'teams/:id/users', to: 'teams#add_user', as: :team_user
  delete 'teams/:id/users/:user_id', to: 'teams#remove_user', as: :remove_team_user


  #User Paths
  resources :users


  #Environments Paths
  resources :environments


  #Execution Paths
  resources :executions
  get 'executions/:id/testcase_detail/:testcase_id', to: 'executions#testcase_detail', as: :testcase_detail
  put 'executions/:id/close', to: 'executions#close', as: :close_execution
  get 'executions/:id/project_execution_summary/:title', to: 'executions#project_summary', as: :execution_project_summary
  get 'executions/:id/environment_overview', to: 'executions#environment_overview', as: :execution_environment_overview
  get 'executions/:id/next_test', to: 'executions#next_test', as: :next_test
  post 'executions/:id/runner_result', to: 'results#runner_result', as: :runner_result


  #Result Paths
  resources :results
  get 'results/:id/history', to: 'executions#result_history', as: :result_history
  get 'results/:id/screenshot/:screenshot_id', to: 'results#screenshot', as: :result_screenshot
end
