class ChangeTasksColumnNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :title, :string, limit:80
    change_column_null :tasks, :title, false
    change_column :tasks, :content, :text, limit:1000
    change_column_null :tasks, :content, false
  end
end