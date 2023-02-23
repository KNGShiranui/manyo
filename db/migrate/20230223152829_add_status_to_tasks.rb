class AddStatusToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :status, :string, null: false, default: -> { 'NOW()' }
    # カラム作成時にstatusが空のものがあるとエラーになるので、空の部分には現在の時刻をデフォルトで入力
  end
end
