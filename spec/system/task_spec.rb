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
      end
    end
  end
  
  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        task = FactoryBot.create(:task, title: 'task', content: 'task_content')
        visit tasks_path
        expect(page).to have_content 'task'
      end
    end
  end

  describe '詳細表示機能' do
    before do
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

  describe '日付降順' do
    before do
      FactoryBot.create(:task, title: 'show1', content: 'show1_content')
      FactoryBot.create(:second_task, title: 'show2', content: 'show2_content')
      FactoryBot.create(:task, title: 'show3', content: 'show3_content')
      FactoryBot.create(:second_task, title: 'show4', content: 'show4_content')
    end
    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        visit tasks_path
        task_list = page.all('.task_row')
        expect(task_list[0]).to have_content 'show4_content'
        expect(task_list[1]).to have_content 'show3_content'
        expect(task_list[2]).to have_content 'show2_content'
        expect(task_list[3]).to have_content 'show1_content'
      end
    end
  end
end