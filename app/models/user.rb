class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30}
  validates :email, presence: true, length: { maximum: 255}, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  before_validation { email.downcase! }
  has_secure_password
  has_many :tasks, dependent: :destroy
  validates :password, length: { minimum: 6 }
  before_update :can_not_update_administrator 
  before_destroy :can_not_destroy_administrator

  private
  def can_not_destroy_administrator
      @administrator = User.where(administrator: true)
    if @administrator.count == 1 && self.administrator == true
      throw :abort
    end
  end

  def can_not_update_administrator
      @administrator = User.where(administrator: true)
    if @administrator.count == 1 && self.administrator == false
      throw :abort
    end
  end
end

