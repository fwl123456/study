class Article
  include Mongoid::Document
  paginates_per 5
  field :title, type: String
  field :text, type: String
  has_many :comments, dependent: :destroy # 文章包含评论 一篇文章可以有多条评论
  validates :title, presence: true, # 确保文章必须有标题
                    length: { minimum: 5 } # 标题长度不少于5
end 
