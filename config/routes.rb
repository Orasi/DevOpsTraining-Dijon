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
  post 'projects/:id/testcases/parse', to: 'testcases#parse', as: :testcase_parse
  post 'projects/:id/testcases/import', to: 'testcases#import'
  get 'projects/:id/testcases/export', to: 'testcases#export', as: :export_testcase


  #Team Paths
  resources :teams
  post 'teams/:id/projects/users', to: 'teams#add_project', as: :team_project
  delete 'teams/:id/projects/:project_id', to: 'teams#remove_project', as: :remove_team_project
  post 'teams/:id/users', to: 'teams#add_user', as: :team_user
  delete 'teams/:id/users/:user_id', to: 'teams#remove_user', as: :remove_team_user


  #User Paths
  resources :users
  get 'users/:id/password_reset/:token', to: 'users#reset_password_form', as: :reset_password_form
  post 'users/:id/reset', to: 'users#reset_password', as: :post_reset_password
  post 'users/forgot-password', to: 'users#forgot_password', as: :forgot_password
  get 'users/:id/password_reset', to: 'users#trigger_password_reset', as: :trigger_password_reset


  #Environments Paths
  resources :environments

  #Keywords Paths
  resources :keywords

  #Execution Paths
  resources :executions
  get 'executions/:id/testcase_detail/:testcase_id', to: 'executions#testcase_detail', as: :testcase_detail
  put 'executions/:id/close', to: 'executions#close', as: :close_execution
  get 'executions/:id/project_execution_summary/:title', to: 'executions#project_summary', as: :execution_project_summary
  get 'executions/:id/project_execution_summary/:title/update', to: 'executions#project_summary_update', as: :execution_project_summary_update
  get 'executions/:id/environment_overview', to: 'executions#environment_overview', as: :execution_environment_overview
  get 'executions/:id/testcase_overview', to: 'executions#testcase_overview', as: :execution_testcase_overview
  get 'executions/:id/next_test', to: 'executions#next_test', as: :next_test
  post 'executions/:id/runner_result', to: 'results#runner_result', as: :runner_result


  #Result Paths
  resources :results
  get 'results/:id/history', to: 'executions#result_history', as: :result_history
  get 'results/:id/screenshot/:screenshot_id', to: 'results#screenshot', as: :result_screenshot
  get 'results/:id/step-log', to: 'results#step_log', as: :step_log

  #Report Paths
  get 'reports/testcase-status/:project_id', to: 'reports#testcase_status_form', as: :testcase_status_form
  post 'reports/testcase-status/:project_id', to: 'reports#testcase_status', as: :testcase_status
end
