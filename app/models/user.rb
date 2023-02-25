class User < ApplicationRecord
  include SessionsHelper
  validates :name, presence: true, length: { maximum: 30}
  validates :email, presence: true, length: { maximum: 255}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  before_validation { email.downcase! }
  has_secure_password
  has_many :tasks, dependent: :destroy
  validates :password, length: { minimum: 6 }
  # before_update :can_not_update_admin
  # before_destroy :can_not_destroy_admin
end

