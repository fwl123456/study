Rails.application.routes.draw do
  get 'welcome/index' # 告诉Rails对0.0.0.0:3000/welcome/index的请求访问请求应该发往welcome控制器的index动作

  resources :articles do# 文章资源
 		resources :comments
 	end
  root 'welcome#index' # 告诉Rails对根路径的访问请求应该发往welcome控制器的index动作
end