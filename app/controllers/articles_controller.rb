class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy, :index]
  before_action :set_labels, only: [:new, :create, :edit, :update]
  before_action :set_article, only: [:show, :edit, :update, :previous, :next, :like, :unlike]
  load_and_authorize_resource
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
      # @articles = Article.where(title: /#{query_text}/).page params[:page]
      @articles = Article.full_text_search(query_text).page params[:page]
    end
    # 天气查询传入城市名查询天气
    @weather = Weather.get_weather(params[:city])
    #文章排序 看前端传入的是order是倒序还是正序进行排序
    @articles = Article.all.order(created_at: params[:order]) unless params[:order].blank?  
    # 从label标签中找到前端传过来的labelname对应的标签，然后找到对应标签的所有文章赋值给文章对象
    @articles = Label.find(params[:label_id]).articles unless params[:label_id].blank?
    # 显示当前用户的文章
    @articles = Article.where(user_id: params[:user_id]) unless params[:user_id].blank?
    # @articles = Article.where(autor_name: current_user.name)  
    # 显示当前文章分页功能
    @articles = @articles.order(position: :asc)
    @articles = @articles.page(params[:page])
  
  end

  # 软删除列表
  def deleted
    @articles = Article.deleted
    @articles = @articles.order(created_at: params[:order]) unless params[:order].blank?  
    @articles = Label.find(params[:label_id]).articles unless params[:label_id].blank?
    @articles = @articles.order(position: :desc)
    @articles = @articles.page(params[:page])
  end

  # 删除
  def destroy
    @article = Article.unscoped.all.find(params[:id]) 
    if @article.deleted_at == nil 
      @article.destroy
      redirect_to articles_path, notice: "文章已放入回收站，7天后自动删除!"
    else
      @article.destroy!
      redirect_to articles_path, notice: "删除成功！"
    end
  end

  # 恢复
  def restore
    # 从文章已删除的列表中找到要恢复的对象
    @article = Article.deleted.find(params[:id])
    @article.restore
    redirect_to articles_path, notice: "恢复成功！"
  end

   # 显示当前用户的文章
  def my_articles
     @articles = current_user.articles
  end

  def show
    # 展示文章 传入文章ID来找到文章对象de
    # @article = Article.find(params[:id])
    # 文章对象调用comments方法得到文章所有评论
    @article.read(current_user)
    @comments = @article.comments
    @readers = User.find(@article.readers)
  end

  def new
    @article = current_user.articles.new
  end

  def edit
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      @article.update(autor_name: current_user.name)
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def update
    if @article.update(article_params)
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  # 上一篇文章
  def previous
    if @article.previous_item == nil

    else
      @article = @article.previous_item
    end
    @readers = User.find(@article.readers)
    render 'show'
  end

  # 下一篇文章
  def next
    if @article.next_item == nil

    else
      @article = @article.next_item
    end
    @readers = User.find(@article.readers)
    render 'show'
  end
  # 喜欢方法
  def like
    @article.like current_user
    @readers = User.find(@article.readers)
    render 'show'
  end
  # 取消喜欢方法
  def unlike
    @article.unlike current_user
    @readers = User.find(@article.readers)
    render 'show'
  end

  # def destroy
  #   @article = Article.find(params[:id])
  #   @article.destroy
  #   redirect_to articles_path
  # end

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

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :text, :autor_name, label_ids: [] )
    # 设置提交参数为title text label_ids
  end
end
