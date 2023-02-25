class AddDuedateToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :due_date, :date, null: false, default: "2999-12-31"
  end
end
