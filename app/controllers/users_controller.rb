class UsersController < ApplicationController
	before_action :authenticate_user!

	def index
    @users = User.all
	end

  def show
    # @user = User.find(params[:id])
    @user = current_user #展示用户对象等于当前登录的用户对象
    # @users = User.all
    # @user = User.find(params[:id])
   
  end
  
  # def user
  # 	render 'show'
  # end
  
  def edit
  	@user = current_user
  end
  
  def update
  	@user = current_user
    if @user.update(user_params)
       redirect_to users_path()
    else
       render 'edit'
  	end
  end

  # def create
  #   @user = User.new(user_params)
  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy
  #   @user = User.find(params[:id])
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_path, notice: 'User was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  def followers
    @followers = current_user.followers
    # render json: current_user.followers
  end

  def followings
    @followings = current_user.followings
    #render json: current_user.followings
  end

  def follow
    # 通过网页传来的id找到要关注的用户对象传入方法进行关注
    follower = User.find(params[:id])
    current_user.follow(follower)
    redirect_to followers_user_path(current_user)
  end

  def unfollow
    # 通过网页传来的id找到要取消关注的用户对象传入方法进行取消关注
    follower = User.find(params[:id])
    current_user.unfollow(follower)
    redirect_to followers_user_path(current_user)
  end

  private
  
    def user_params
		params.require(:user).permit(:name, :age, :sex, :image)
		# 设置提交参数为name age sex
	end
end	   
