class Task < ApplicationRecord
  belongs_to :user
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings, source: :label
  paginates_per 10
  validates :title, presence: true, length: { maximum: 80}
  validates :content, presence: true,  length: { maximum: 1000}
  validates :due_date, presence: true
  validates :status, presence: true
  # default_scope -> { order(created_at: :desc) }
  # ここに記載するとコントローラでの条件分岐より優先して適用される。
  # なので条件分岐が利かなくなるためコメントアウト
  scope :sort_due_date, -> {order(due_date: :desc)}
  scope :sort_priority, -> {order(priority: :desc)}
  scope :latest, -> {order(created_at: :desc)}
  scope :search_title, -> (title){where('title LIKE ?', "%#{title}%")}
  scope :search_status, -> (status){where(status: status)}
  scope :search_title_status, -> (title, status){where('title LIKE ?',"%#{title}%").where(status: status)}
  scope :search_label, -> (label_ids){ where(id: LabelTask.where(label_id: label_ids).pluck(:task_id))}
  # タスクidが1のタスクに関連付けられたラベルのidを取得する例
  # label_ids = LabelTask.where(task_id: 1).pluck(:label_id)
  # TODO:label_idがlabels_idのラベルに関連付けられたタスクのidを取得する例
  # TODO:task_ids = LabelTask.where(label_id: label_ids).pluck(:task_id)
  # 引数がlabel_ids。
  # モデル名.pluck(:カラム名)
  # モデル名.all.map(&:カラム名) # 上記と同じ
  enum priority: { "高": 0, "中": 1, "低": 2 } 
  #enumメソッドは、定義された属性に対して、文字列を指定することで、それに対応する整数値を返すメソッドを自動的に追加
  # 例えば、"高" を指定すると、0 が返される。この属性を利用することで、優先度に関する処理を簡単に行うことができる。
end
