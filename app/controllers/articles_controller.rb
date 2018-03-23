class ArticlesController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]

	def index
		query_text = params[:q]
		if query_text.blank?
			@articles = Article.all.page params[:page]	
		else
			# 显示当前页数页面的文章
			@articles = Article.where(title: /#{query_text}/).page params[:page]		
		end
	end

	def show
	  # 展示文章 传入文章ID来找到文章对象de
		@article = Article.find(params[:id])
		# 文章对象调用comments方法得到文章所有评论
		@comments = @article.comments
	end

	def new
		@article = Article.new
	end

	def edit
		@article = Article.find(params[:id])
	end

	def create
		@article = Article.new(article_params)
		if @article.save
			redirect_to articles_path
		else
			render 'new'
		end
	end

	def update
		@article = Article.find(params[:id])
   	if @article.update(article_params)
      redirect_to articles_path
    else
     render 'edit'
	  end
  end

  def destroy
  	@article = Article.find(params[:id])
  	@article.destroy
  	redirect_to articles_path
  end

  def search
  	@article = Article.find(params[:text])
  	if @article
  		redirect_to article_path(@article)
  	else
  	end
  end
  
	private
	
	def article_params
		params.require(:article).permit(:title, :text)
		# 设置提交参数为title text 
	end
end
