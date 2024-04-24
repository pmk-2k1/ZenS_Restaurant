class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  def jwt_payload
    super
  end


  mount_uploader :avatar, AvatarUploader
  
  enum :gender,[:"Khác", :"Nam", :"Nữ"]
  enum :role, [:"Khách hàng", :"Nhân viên"]

  validates :fullname, presence: true, length: { minimum: 3, maximum: 50 }
  validates :address, presence: true, length: { maximum: 256 }
  validates :email, uniqueness: true, length: { miximum: 11, maximum: 100 },
                    format: { with: /\A[\w+_.]+@[a-z\d]+\.[a-z]+\z/i }
  validates :username, presence: true, length: { minimum: 1, maximum: 25 }
  validates :password, presence: true
end
