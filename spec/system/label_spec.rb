require 'rails_helper'
RSpec.describe 'ラベリング機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }
  let!(:label) { FactoryBot.create(:label) }  

  def login
      visit new_session_path
      fill_in 'session_email', with: 'KNG@example.com'
      fill_in 'session_password', with: '11101252'
      click_on "ログインする"
  end
  context 'タスクを新規作成した場合' do
    it 'ラベル登録可能' do
      login
      click_on 'タスク一覧'
      click_button 'タスク作成'
      fill_in "task_title", with: "万葉進まんよう"
      fill_in "task_content", with: "万葉課題を進める"
      fill_in "task_due_date", with: "2023-12-31"
      select '完了', from: 'task[status]'
      select '高', from: 'task[priority]'
      check 'step1'
      click_on "Create Task"
      expect(page).to have_content "step1"
    end
  end

  context '任意のタスク詳細画面に遷移した場合' do
    it '該当タスクの内容が表示される' do
      login
      click_on 'タスク一覧'
      click_button 'タスク作成'
      fill_in "task_title", with: "万葉進まんよう"
      fill_in "task_content", with: "万葉課題を進める"
      fill_in "task_due_date", with: "2023-12-31"
      select '完了', from: 'task[status]'
      select '高', from: 'task[priority]'
      click_on "Create Task"
      click_on '編集'
      check 'step1'
      click_on "Update Task"
      expect(page).to have_content "step1"
    end
  end

  context "タスクの詳細画面に遷移した場合" do
    it "そのタスクに紐づいているラベル一覧を出力する" do
      login
      click_on 'タスク一覧'
      click_button 'タスク作成'
      fill_in "task_title", with: "万葉進まんよう"
      fill_in "task_content", with: "万葉課題を進める"
      fill_in "task_due_date", with: "2023-12-31"
      select '完了', from: 'task[status]'
      select '高', from: 'task[priority]'
      check 'step1'
      click_on "Create Task"
      click_on "戻る"
      click_on "詳細", match: :first
      expect(page).to have_content 'step1'
      expect(page).to have_content '万葉進まんよう'
    end
  end

  context "タスクにラベルを登録した場合" do
    it "つけたラべルで検索ができる" do
      login
      click_on 'タスク一覧'
      click_button 'タスク作成'
      fill_in "task_title", with: "万葉進まんよう"
      fill_in "task_content", with: "万葉課題を進める"
      fill_in "task_due_date", with: "2023-12-31"
      select '完了', from: 'task[status]'
      select '高', from: 'task[priority]'
      check 'step1'
      click_on "Create Task"
      click_on "戻る"
      check 'step1'
      click_button "検索"
      expect(page).to have_content 'step1'
      expect(page).to have_content '万葉進まんよう'
    end
  end
end