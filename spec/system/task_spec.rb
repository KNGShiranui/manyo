# require 'selenium-webdriver'
# Selenium::WebDriver::Chrome::Service.driver_path = '//wsl.localhost/Ubuntu/home/kengo/workspace/chromedriver_win64/chromedriver'

require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in "task_title", with: "万葉進まんよう"
        fill_in "task_content", with: "万葉課題を進める"
        click_on "Create Task"
        expect(page).to have_content "万葉進まんよう"

        task = FactoryBot.create(:task, title: 'task', content: 'task_content')
        visit task_path(task)
        expect(page).to have_content 'task'
        # expect(page).to have_content 'task_failure'
      end
    end
  end
  
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        task = FactoryBot.create(:task, title: 'task', content: 'task_content')
        # インスタンス変数でないのは、たぶんメソッドを超えて変数を使い回す必要がないから（というか、そうしない方がいいから？）
        # タスク一覧ページに遷移
        visit tasks_path
        # visitした（遷移した）page（タスク一覧ページ）に「task」という文字列が
        # have_contentされているか（含まれているか）ということをexpectする（確認・期待する）
        expect(page).to have_content 'task'
        # expectの結果が true ならテスト成功、false なら失敗として結果が出力される
      end
    end
  end

  describe '詳細表示機能' do
    before do
      # あらかじめタスク一覧のテストで使用するためのタスクを二つ作成する
      FactoryBot.create(:task, title: 'show1', content: 'show1_content')
      FactoryBot.create(:second_task, title: 'show2', content: 'show2_content')
    end
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, title: 'show1', content: 'show1_content')
        visit task_path(task)
        expect(page).to have_content 'show'
      end
    end
  end
end