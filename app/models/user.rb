# frozen_string_literal: true

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
  enum :gender, %i[Khác Nam Nữ]
  enum :role, [:"Khách hàng", :"Nhân viên"]

  validates :fullname, presence: true, length: { minimum: 3, maximum: 50 }
  validates :address, presence: true, length: { maximum: 256 }
  validates :email, uniqueness: true, length: { miximum: 11, maximum: 100 },
                    format: { with: /\A[\w+_.]+@[a-z\d]+\.[a-z]+\z/i }
  validates :username, presence: true, length: { minimum: 1, maximum: 25 }
  validates :password, presence: true

  has_many :blacklisted_tokens, dependent: :delete_all


  def self.decode_refresh_token(token)
    blacklisted_token = BlacklistedToken.find_by(jti: token)
    raise JWT::DecodeError, 'Token has been blacklisted' if blacklisted_token.present?

    secret_key = Rails.application.credentials.devise_jwt_secret_key
    payload = JWT.decode(token, secret_key, true, algorithm: 'HS256').first
    user = User.find(payload['sub'])
    BlacklistedToken.create(jti: token, user:) if user.present?
    user
  end

  def generate_refresh_token
    secret_key = Rails.application.credentials.devise_jwt_secret_key
    jti = SecureRandom.uuid
    payload = { sub: id, jti: }
    JWT.encode(payload, secret_key, 'HS256')
  end


  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 2.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end
