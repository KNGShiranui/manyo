class Labeling < ApplicationRecord
  belongs_to :task
  belongs_to :Labeling
end
