class Label < ApplicationRecord
  has_many :labelings, dependent: :destroy
  has_many :tasks, through: :labelings, source: :task
  validates :name, presence: true, length: { maximum: 20 }
end
