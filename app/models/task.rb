class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 80}
  validates :content, presence: true,  length: { maximum: 1000}
  validates :due_date, presence: true
  validates :status, presence: true
  # default_scope -> { order(created_at: :desc) }
  # ここに記載するとコントローラでの条件分岐より優先して適用される。
  # なので条件分岐が利かなくなるためコメントアウト
end
