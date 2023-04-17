class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable
  devise :database_authenticatable, :rememberable, :validatable

  enum role: {user: 0, admin: 1}

  def name
    email.split("@").first
  end
end
