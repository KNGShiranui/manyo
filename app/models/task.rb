class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 80}
  validates :content, presence: true,  length: { maximum: 1000}
  validates :due_date, presence: true
  validates :status, presence: true
  # default_scope -> { order(created_at: :desc) }
  # ここに記載するとコントローラでの条件分岐より優先して適用される。
  # なので条件分岐が利かなくなるためコメントアウト
  scope :search_title, -> (title){where('title LIKE ?', "%#{title}%")}
  scope :search_status, -> (status){where(status: status)}
  scope :search_title_status, -> (title, status){where('title LIKE ?',"%#{title}%").where(status: status)}
end
