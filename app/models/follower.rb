class Follower
  include Mongoid::Document
  field :follower type:Array, default: []  # 关注我的
  field :following type:Array, default: [] # 我关注的
  has_and_belongs_to_many :users 
end
