require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  before do
    FactoryBot.create(:task)
    FactoryBot.create(:second_task)
    FactoryBot.create(:third_task)
  end
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in "task_title", with: "万葉進まんよう"
        fill_in "task_content", with: "万葉課題を進める"
        fill_in "task_due_date", with: "2023-12-31"
        select '完了',from: 'task[status]'
        select '高',from: 'task[priority]'
        click_on "Create Task"
        expect(page).to have_content "万葉進まんよう"
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

  describe '終了期限降順ソート' do
    before do
      FactoryBot.create(:task, title: 'show1', content: 'show1_content', due_date: '2023-12-31')
      FactoryBot.create(:task, title: 'show2', content: 'show2_content', due_date: '2024-12-31')
      FactoryBot.create(:task, title: 'show3', content: 'show3_content', due_date: '2025-12-31')
      FactoryBot.create(:task, title: 'show4', content: 'show4_content', due_date: '2026-12-31')
    end
    context 'タスクが期日降順で並んでいる場合' do
      it '期日が先のタスクであればあるほど上に表示される' do
        visit tasks_path
        click_on "終了期限でソート"
        sleep(1)
        task_list = all('.task_row')  # allはpage.allでもいい
        expect(task_list[0]).to have_content '2026-12-31'
        expect(task_list[3]).to have_content '2023-12-31'
      end
    end
  end

  describe '検索機能' do
    context 'タイトルであいまい検索をした場合' do
      it "検索キーワードを含むタスクで絞り込まれる" do
        visit tasks_path
        fill_in "task[title]", with: "デフォルトのタイトル1"
        click_on "検索"
        expect(page).to have_content 'デフォルトのタイトル1'
      end
    end
    context 'ステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        visit tasks_path
        select "着手中", from: 'task[status]'
        click_on "検索"
        expect(page).to have_content '着手中'
      end
    end
    context 'タイトルのあいまい検索とステータス検索をした場合' do
      it "検索キーワードをタイトルに含み、かつステータスに完全一致するタスク絞り込まれる" do
        visit tasks_path
        fill_in "task[title]", with: "デフォルトのタイトル2"
        select "未着手", from: 'task[status]'
        click_on "検索"
        # save_and_open_page
        expect(page).to have_content "デフォルトのタイトル2"
        expect(page).to have_content '未着手'
      end
    end
  end
end