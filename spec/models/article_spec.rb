require 'rails_helper'

RSpec.describe Article, type: :model do
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

    it '文章被用户浏览' do
    # 一个用户浏览
      result = @article.read(@user) 
      expect(@article.read_numbers).to eq 1
    end

    it '文章被用户重复浏览' do
      result = @article.read(@user)
      expect(@article.read_numbers).to eq 1
      result = @article.read(@user)
      expect(@article.read_numbers).to eq 1
    end

    it '文章被多个用户浏览' do
      @article.read(@user)
      @article.read(@user)
      @article.read(@user)
      @article.read(@user1)
      @article.read(@user1)
      expect(@article.read_numbers).to eq 2
    end

    it '查看所有浏览过文章的用户' do
      @article.read(@user)
      @article.read(@user1)
      expect(@article.readers.count).to eq 2
      expect(@article.readers).to eq [@user, @user1]
    end
  
	end
end