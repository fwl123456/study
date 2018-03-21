class Comment
  include Mongoid::Document
  field :commenter, type: String
  field :body, type: String
 	belongs_to :article # 评论属于文章  每一条评论都属于某一篇文章
end
