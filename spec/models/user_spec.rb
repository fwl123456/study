require 'rails_helper'
RSpec.describe User, type: :model do 
	describe '验证' do
		before :each do 
			# 运行下面的测试之前先new一个空的user对象
			@user = build(:user, name: '', password: '', email: '')
		end

		it '用户名,密码，邮箱不能为空' do
			#  expect(@user).to be
			expect(@user.valid?).to be false
			expect(@user.errors[:name].any?).to be true
			expect(@user.errors[:password].any?).to be true
			expect(@user.errors[:email].any?).to be true
			expect(@user.errors[:name].first).to eq "can't be blank"
			expect(@user.errors[:password].first).to eq "can't be blank"
			expect(@user.errors[:email].first).to eq "can't be blank"
		end
 	end
	describe '关注' do
		it '关注' do
			# 关注需要创建2个用户
			@user1 = create(:user, name: 'user1', email: 'user1@aaa.com')
			@user2 = create(:user, name: 'user2', email: 'user2@aaa.com')
			# 创建出来的2个用户关注数和被关注数都是0
			expect(@user1.followers_count).to eq 0
			expect(@user1.followings_count).to eq 0
			expect(@user2.followings_count).to eq 0
			expect(@user2.followers_count).to eq 0
			# 用户1关注用户2调用follow方法传入关注对象  第一次方法返回状态为1，第二次为-1
			result = @user1.follow(@user2)
			# 第一次关注返回状态是1，关注成功
			expect(result[:status]).to eq 1
			# 关注成功后user1的关注数followers_count增加1，followings_count被关注数还是0
			expect(@user1.followers_count).to eq 1
			expect(@user1.followings_count).to eq 0
		  # 关注成功后user2的关注数followers_count还是0，followings_count被关注数增加1
			expect(@user2.followers_count).to eq 0
			expect(@user2.followings_count).to eq 1
			# 关注成功后user1里面的关注者包含user2（被关注者）
			expect(@user1.followers).to include @user2
			# 关注成功后user2里面的被关注者包含user1（关注者）
			expect(@user2.followings).to include @user1
		end

		it '取消关注' do
			@user1 = create(:user, name: 'user1', email: 'user1@aaa.com')
      @user2 = create(:user, name: 'user2', email: 'user2@aaa.com')		
      @user1.follow(@user2)
      result = @user1.unfollow(@user2)
      expect(result[:status]).to eq 1
      expect(@user1.followers_count).to eq 0
			expect(@user1.followings_count).to eq 0
			expect(@user2.followers_count).to eq 0
			expect(@user2.followings_count).to eq 0
			expect(@user1.followers).not_to include @user2
			expect(@user2.followings).not_to include @user1
		 #  expect(@user1.followers.include? @user2).to eq false
		 #  expect(@user2.followings.include? @user1).to eq false
    end

		it '重复关注' do
			@user1 = create(:user, name: 'user1', email: 'user1@aaa.com')
			@user2 = create(:user, name: 'user2', email: 'user2@aaa.com')
			@user1.follow(@user2)
			result = @user1.follow(@user2)
			expect(@user1.followers_count).to eq 1
			expect(@user1.followings_count).to eq 0
			expect(@user2.followers_count).to eq 0
			expect(@user2.followings_count).to eq 1
			expect(result[:status]).to eq -1
		end
	end
end
