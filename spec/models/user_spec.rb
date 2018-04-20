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
end
