class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :set_labels, only: [:new, :create, :edit, :update]

  def index
    # 把网页提交的参数给query_text装起来
    query_text = params[:q]
    # 判断如果内容为空
    if query_text.blank?
      # 就显示当前页面文章
      @articles = Article.all.page params[:page]
    else
      # 显示当前页数页面的文章
      # 否则把参数传到Article里面查找并把页面显示出来  /#{query_text}/为模糊查询
      @articles = Article.where(title: /#{query_text}/).page params[:page]
    end
    # 天气查询传入城市名查询天气
    @weather = Weather.get_weather(params[:city])
    #文章排序 看前端传入的是order是倒序还是正序进行排序
    @articles = Article.all.order(created_at: params[:order]) unless params[:order].blank?  
    # 从label标签中找到前端传过来的labelname对应的标签，然后找到对应标签的所有文章赋值给文章对象
    @articles = Label.find(params[:label_id]).articles unless params[:label_id].blank?
    # 显示当前文章分页功能
    @articles = @articles.page params[:page]
  end

  def show
    # 展示文章 传入文章ID来找到文章对象de
    @article = Article.find(params[:id])
    # 文章对象调用comments方法得到文章所有评论
    @comments = @article.comments
    Article.read(@user)
    @readers = @article.readers
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
  # # 文章降序排序
  # def desc 
  #   @articles = Article.all.order(created_at: :desc).page params[:page]
  #   @weather = Weather.get_weather(params[:city]) # 天气查询需要weather对象
  #   render :index
  # end
  # # 文章正序排序
  # def asc
  #   @articles = Article.all.order(created_at: :asc).page params[:page]
  #   @weather = Weather.get_weather(params[:city])  # 天气查询需要weather对象
  #   render :index
  # end

  private
  def set_labels
    @labels = Label.all
  end

  def article_params
    params.require(:article).permit(:title, :text, label_ids: [])
    # 设置提交参数为title text label_ids
  end
end
