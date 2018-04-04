Rails.application.routes.draw do
  resources :labels
	devise_for :users, controllers: {sessions: 'users/sessions'}
  get 'welcome/index' # 告诉Rails对0.0.0.0:3000/welcome/index的请求访问请求应该发往welcome控制器的index动作

  namespace :api, defaults: {format: :json} do
  	namespace :v1 do
  		resources :articles
      resources :labels
  	end
  end

  resources :articles do # 文章资源
 		resources :comments
 		collection do  # 全部
 			get :desc    #desc方法是get请求
 			get :asc		 #asc方法是get请求
 		end
  resources :labels

 	end
 	resource :user # 用户资源
  root to: 'articles#index' # 告诉Rails对根路径的访问请求应该发往welcome控制器的index动作
  #root to: 'user#show'
end
