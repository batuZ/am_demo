class SessionsController < ApplicationController
  
  def new
  end

  #登录
  def create
  	#从数据库中找匹配u_name的对象
  	@user = User.find_by(name: params[:session][:name].downcase)

  	#判断是否存在且匹配
  	if @user && @user.authenticate(params[:session][:password])

  		#记录下这个id进行保持 
  		session[:user_id] = @user.id
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  #登出
  def destroy
  	session.delete(:user_id)
  	render 'new'
  end

end
