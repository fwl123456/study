require 'rails_helper'

RSpec.describe User, type: :model do
	describe '浏览' do
		before :each do
			@user = create(:user)
			@article = create(:article, user: @user)
			@user1 = create(:user, name: 'fwl', email: 'aaa@lindo.io', password: '123123')
		end


		it '查看文章浏览数' do
			# 没人浏览时，浏览数为0
			expect(@article.read_numbers).to eq 0
		end
	end
end