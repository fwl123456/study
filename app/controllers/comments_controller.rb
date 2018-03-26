class CommentsController < ApplicationController
	def create
		# 先拿到要评论的文章
		@article = Article.find(params[:article_id])
		# 在拿到的文章里创建评论（传入网页评论的内容）
		@comment = @article.comments.create(comment_params)
		# 最后重定向到此文章的页面
		redirect_to article_path(@article)
	end

	def destroy
		# 先拿到要删除的文章
    @article = Article.find(params[:article_id])
    # 在拿到的文章里面传入一个评论的ID找到该评论
    @comment = @article.comments.find(params[:id])
    # 删除找到的评论
    @comment.destroy
    # 最后从定向到此文章的页面
    redirect_to article_path(@article)
  end

	private

	def comment_params
		# 设置提交参数为 commenter和body
		params.require(:comment).permit(:commenter, :body)
	end
  
end 
