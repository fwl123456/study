require "redis"
class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  paginates_per 5
  field :title, type: String
  field :text, type: String
  field :read_numbers, type: Integer, default: 0
  field :readers, type: Array, default: []
  belongs_to :user # 文章属于用户
  has_many :comments, dependent: :destroy # 文章包含评论 一篇文章可以有多条评论 dependent 删除关联对象 文章删除后，文章评论也应该删除
  has_and_belongs_to_many :labels
  validates :title, presence: true, # 确保文章必须有标题
                    length: { minimum: 5 } # 标题长度不少于5
  # 浏览方法，传入一个文章对象
  def read(user)
    result = $redis.sadd "article:#{self.id.to_s}:read_numbers", user.id.to_s
    if result == true
        self.inc(read_numbers: 1)
        reader = self.readers
        # 保存浏览过文章的人到readers
        self.update(readers: reader.push(user.id.to_s))
    end
  end
  # 查看浏览过文章的所有人
  def select_readers
    user_ids = $redis.smembers "article:#{self.id.to_s}:read_numbers"
    self.readers = User.find(user_ids)
  end


end
