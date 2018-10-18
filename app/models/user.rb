class User < ApplicationRecord
  has_secure_password
  validates :first_name, presence: false
  validates :last_name, presence: false
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 8 }, presence: true
end
