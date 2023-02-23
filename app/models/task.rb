class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 80}
  validates :content, presence: true,  length: { maximum: 1000}
  validates :due_date, presence: true
  default_scope -> { order(created_at: :desc) }
end
