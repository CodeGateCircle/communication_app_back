# frozen_string_literal: true

# user
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  # 中間テーブル
  has_many :workspace_users, dependent: :destroy
  has_many :workspaces, through: :workspace_users

  has_many :room_users, dependent: :destroy
  has_many :rooms, through: :room_users
  has_many :messages
  has_one_attached :user_image

  def self.from_omniauth(auth)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.create(
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name,
      image: auth.info.image,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20]
    )
    user
  end
end
