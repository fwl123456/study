Rails.application.routes.draw do
  resources :labels
  # 用户资源
  # resources :users
  # get 'users' , to: 'users#index'
  # get 'users/followers', to: 'users#followers'
  # get 'users/followings', to: 'users#followings'
  # delete 'unfollow', to: 'users#unfollow' 
  # put 'users/:id', to: 'users#unfollow'
  # get 'user', to: 'users#show'
  # 用户资源  only只生成show，index，update，edit四个路由，不写默认生成7个
  resources :users, only: [:index, :update, :edit, :new, :destory] do
    # member do对用户的单个资源进行操作
    member do
      get 'followers'
      get 'followings'
      delete 'unfollow'
      get 'follow'
    end
    # collection对所有用户的某个资源进行操作
    # collection do
    #   post 'aaa'
    # end
  end 
  
	devise_for :users, controllers: {sessions: 'users/sessions'}
  #get 'welcome/index' # 告诉Rails对0.0.0.0:3000/welcome/index的请求访问请求应该发往welcome控制器的index动作

  namespace :api, defaults: {format: :json} do
  	namespace :v1 do
  		resources :articles
      resources :labels
      namespace :admin do
        resources :articles
      end
  	end
  end

  resources :articles do # 文章资源
    # 嵌套资源
    resources :comments 
    resources :labels
    collection do
      get 'deleted'
    end
    member do
      post 'restore'
      get 'previous'
      get 'next'
      put 'like'
      put 'unlike'
      get 'likers'
    end
 	end

  root to: 'articles#index' # 告诉Rails对根路径的访问请求应该发往articles控制器的index动作
  #root to: 'user#show'
end
