# Copyright (c) 2015 - 2020 Ana-Cristina Turlea <turleaana@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

Rails.application.routes.draw do


  resources :teachers do
    get 'delete'
    match 'import', :via => [:get, :post], :as => 'import'
    get 'download'
    get 'import_from_app'
  end
  resources :departments do
    get 'delete'
  end
  resources :forms do
    get 'delete'
  end
  resources :courses do
    get 'delete'
    match 'reset', :via => [:get, :post], :as => 'reset'
    match 'import', :via => [:get, :post], :as => 'import'
    get 'download'

  end
  resources :activities do
    get 'delete'
    get 'editS'
    get 'deleteS'
    get 'destroyS'
    get 'newS'
    match 'updateS', :via => [:patch, :post]
    get 'deleteall'
  end

  resources :cohorts do
    get 'delete'
    match 'import', :via => [:get, :post], :as => 'import'
    get 'import_from_app'
    get 'download'
  end
  resources :evaluation_sessions do
    get 'delete'
    match 'activate', :via => [:get, :post], :as => 'activate_session'
    match 'finalize', :via => [:get, :post], :as => 'finalize_session'
    match 'generate', :via => [:get, :post], :as => 'generate'
    get 'get_tokens'
  end

  get 'get_comments', :to => 'evaluation_sessions#get_comments'
  get 'get_comments_p', :to => 'prof#get_comments'
  match 'view_evaluation', :via => [:get, :post], :to => 'evaluation_sessions#view_evaluation'
  get 'descarca', :to => 'evaluation_sessions#descarca', :format => 'pdf'
  get 'download_evaluation', :to => 'evaluation_sessions#download_evaluation', :format => 'pdf'
  get 'download_evaluation_p', :to => 'prof#download_evaluation', :format => 'pdf'

  get 'evaluate' => 'evaluation#index'
  match 'evaluate_activity', :via => [:post, :get], :to => 'evaluation#evaluate_activity'
  match 'view_evaluation', :via => [:post, :get], :to => 'evaluation#view_evaluation'
  match 'view_eval_p', :via => [:post, :get], :to => 'prof#view_evaluation'

  match 'course_list', :via => [:post, :get], :to => 'courses#course_list'
  match 'cohort_list', :via => [:post, :get], :to => 'cohorts#cohort_list'
  match 'activities_neterminal_list', :via => [:post, :get], :to => 'evaluation_sessions#activities_neterminal_list'
  match 'activities_terminal_list', :via => [:post, :get], :to => 'evaluation_sessions#activities_terminal_list'

  get 'home/index'

  match 'set_visibility' , :via => [:post, :get], :to => 'evaluation_sessions#set_visibility'


  post 'create_active_user' => 'home#create'

  get 'view_statistics' => 'statistics#index'
  get 'download_all', :to => 'statistics#download_all'
  get 'download_by_cohorts', :to => 'statistics#download_by_cohorts'

  get 'course_statistics/:course_id' => 'statistics#course_statistics'
  get 'teacher_statistics/:teacher_id' => 'statistics#teacher_statistics'

  get 'evaluation_form/:activity_id' => 'evaluation#eval_form'

  get 'form_archive' =>'form#list_all'



  get 'control_panel' => 'control_panel#index'
  get 'control_panel/:tab' => 'control_panel#index'


  #get 'admin' => 'admin#index'

  get 'admin' => 'evaluation_sessions#current_session'

  get 'prof/index'

  get 'new_session' => 'evaluation_sessions#new1'
  get 'evaluation_sessions' => 'evaluation_sessions#index'

  get 'delete_all_activities_for_exam' => 'activities#delete_all_activities_for_exam'

  root 'home#index'

  match '/token_sign_out', to: 'home#abort_token_session', as: 'token_sign_out', via: [:get, :post]

  # omniauth
  match '/auth/:provider/callback', :via => [:get, :post], :to => 'user_sessions#create'
  match '/auth/failure', :via => [:get, :post], :to => 'user_sessions#failure'

  # Custom logout
  match '/logout', :via => [:get, :post], :to => 'user_sessions#destroy'

  #match 'test', :via => [:get], :to => 'cohorts#getAllCohorts'

end
