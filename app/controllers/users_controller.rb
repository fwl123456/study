class UsersController < ApplicationController
	before_action :authenticate_user!
def show
	@user = current_user #展示用户对象等于当前登录的用户对象
end

def user
	render 'show'
end

def edit
	@user = current_user
end

def update
	@user = current_user
  if @user.update(user_params)
     redirect_to user_path()
  else
     render 'edit'
	end
end

private

  def user_params
		params.require(:user).permit(:name, :age, :sex, :image)
		# 设置提交参数为name age sex
	end
end	   
