class MembersController < UsersController
before_action :authenticate_user!
  def show
    @user = current_user #展示用户对象等于当前登录的用户对象
  end

  def followers
    @followers = current_user.followers
    # render json: current_user.followers
  end

  def followings
    @followings = current_user.followings
    #render json: current_user.followings
  end

  def unfollow
    current_user.unfollow(follower)
  end

  def follow
    current_user.follow(follower)
  end
end
