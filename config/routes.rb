Rails.application.routes.draw do

  root 'sessions#new'

  resources :users do
  	resources :projects, shallow: true
  end

  resources :projects, only: [] do 
    resources :groups, shallow: true
  end

  resources :groups, only: [] do
    resources :photos, shallow: true
  end 

  get 'login' => 'sessions#new'	#显视登录页面
	post 'login' => 'sessions#create'	#显视注册页面
	delete 'logout' => 'sessions#destroy'	#登出
end
