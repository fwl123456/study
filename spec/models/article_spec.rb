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
      expect(@article.read_numbers).to eq 2
      expect(@article.select_readers).to eq [@user, @user1]
    end


    it '验证文章标题不能为空' do
    @article = build(:article, title: '', text: "This is a text2")
    expect(@article.valid?).to be false
    expect(@article.errors[:title].any?).to be true
    expect(@article.errors[:title].first).to eq "can't be blank"
    expect(@article.errors[:title].last).to eq "is too short (minimum is 5 characters)" 
    end
  end
  describe '软删除' do
    before :each do
      @user = create(:user)
      @article = create(:article, user: @user)
      @user1 = create(:user, name: 'fwl', email: 'aaa@lindo.io', password: '123123')
      @article1 = create(:article, user: @user1)
      @article2 = create(:article, user: @user1)
    end
 
    it '查看回收站' do
    # 没有删除文章时 回收站为空
      expect(Article.deleted.count).to eq 0
    end

    it '删除一条文章' do
      @article.destroy
      expect(Article.count).to eq 2
      expect(Article.deleted.count).to eq 1
      expect(Article.deleted).to include @article
    end

    it '删除多条文章' do
      @article.destroy
      @article1.destroy
      expect(Article.count).to eq 1
      expect(Article.deleted.count).to eq 2
      expect(Article.deleted).to include @article, @article1 
    end

    it '回收站删除文章' do
      @article.destroy!
      expect(Article.count).to eq 2
      expect(Article.deleted.count).to eq 0
      @article1.destroy!
      expect(Article.count).to eq 1
      expect(Article.deleted.count).to eq 0
    end

    it '回收站文章恢复' do
      @article.destroy
      @article1.destroy
      @article2.destroy
      @article.restore
      @article1.restore
      @article2.restore
      expect(Article.count).to eq 3
      expect(Article.all).to include @article, @article1, @article2 
      expect(Article.deleted.count).to eq 0
    end

    it '文章首页排序' do
      expect(@article.position).to eq 1
      expect(@article1.position).to eq 2
      expect(@article2.position).to eq 3
    end

    # it '文章上移' do
    #   @article1.move_higher
    #   @article1.move_higher
    #   @article1.move_higher
    #   expect(@article1.position).to eq 1
    #   @article2.move_higher
    #   expect(@article1.position).to eq 1
    # end

  end
end
