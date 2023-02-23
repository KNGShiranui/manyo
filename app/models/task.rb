class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 80}
  validates :content, presence: true,  length: { maximum: 1000}
  default_scope -> { order(created_at: :desc) }
end
