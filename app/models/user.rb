class User
  include Mongoid::Document
  ROLES = [:admin, :user, :collecter]# roles三种类型 管理员 用户和其他
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String


  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  field :name, type: String
  field :age, type: Integer
  field :sex, type: String
  # 我关注的用户数量
  field :followers_count, type: Integer, default: 0
  # 关注我的用户数量
  field :followings_count, type: Integer, default: 0
  # 用户和用户关系自对应多对多
  has_and_belongs_to_many :followers, class_name: 'User',  inverse_of: :followings
  has_and_belongs_to_many :followings, class_name: 'User', inverse_of: :followers
  # field :followings, type: Array, default: [] # 我关注的用户数量
  # 角色
  field :role, type: String
  has_many :articles # 用户包含多篇文章
  # has_and_belongs_to_many :followers  # 一个用户可以关注多个用户 多个用户可以关注一个用户
  validates :name, presence: true, # 确保User必须有name
                   length: { minimum: 2 } #名字长度不少于2

 
  def admin?
    role == 'admin'
  end

  # 图片
  mount_uploader :image, AvatarUploader

  # # 查看我关注的人
  # def select_followings
  #   user_ids = $redis.smembers "user:#{self.id.to_s}:follow_numbers"
  #   self.followings = User.find(user_ids)
  # end

  # # 查看关注我的人
  # def select_followers
  #   user_ids = $redis.smembers "user:#{self.id.to_s}:follow_numbers"
  #   self.followers = User.find(user_ids)
  # end

  # 关注方法
  def follow(follower)
    if self.followers.include? follower 
      { status: -1, notice: "你已经关注过#{follower.name}" }
    elsif self == follower
      { status: -2, notice: "不能关注自己" }
    else
      # 在用户的关注者里面放入被关注的用户follower
      self.followers << follower
      self.inc(followers_count: 1)
      follower.inc(followings_count: 1)
      { status: 1, notice: '关注成功' }
    end
  end
  
  # 取消关注方法
  def unfollow(follower)
    # 判断当前用户是否关注了 取消关注用户对象
    if self.followers.include? follower
    # 当前用户关注了取消关注的用户对象时,从关注者中移除取消关注对象
      self.followers.delete(follower)
    # 关注者的人数减 1
      self.inc(followers_count: -1)
    # 取消关注者对象中关注我的人数减 1  
      follower.inc(followings_count: -1)
      { status: 1, notice: '成功取消关注' }
    else
      # 否者没有关注 取消关注的用户对象
      { status: -1, notice: "你还没有关注#{follower.name}" }
    end
  end
end