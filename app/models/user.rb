class User
  include Mongoid::Document
  ROLES = [:admin, :user, :collecter]
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

end


# <%= current_user.name %>