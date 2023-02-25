class Task < ApplicationRecord
  belongs_to :user
  paginates_per 10
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
  enum priority: { "高": 0, "中": 1, "低": 2 } 
  #enumメソッドは、定義された属性に対して、文字列を指定することで、それに対応する整数値を返すメソッドを自動的に追加
  # 例えば、"高" を指定すると、0 が返される。この属性を利用することで、優先度に関する処理を簡単に行うことができる。
end
