# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  # dependent: :destroy приговаривает связанные микросообщения (т.e., те что принадлежат данному пользователю) быть уничтоженными при уничтожении самого пользователя
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # before_save { |user| user.email = email.downcase }
  before_save { email.downcase! }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    # Это предварительное решение. См. полную реализацию в "Following users".
    Micropost.where("user_id = ?", id)
  end

  # метод following? принимает пользователя, названного other_user и проверяет, существует ли он в базе данных
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  # метод follow! вызывает create! через relationships ассоциацию для создания взаимоотношения с читаемым
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  # Прекращение слежения за сообщениями пользователя посредством уничтожения взаимоотношения
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private   #All methods defined in a class after private are automatically hidden
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64   #self обеспечивает установку назначением пользовательского remember_token - он будет записан в DB вместе с другими атрибутами при сохранении пользователя.
    end  
end
