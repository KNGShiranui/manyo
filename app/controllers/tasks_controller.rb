class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  # 以下の記述でソートを許可するカラム名を一覧で定義。
  SORTABLE_FIELDS = %w[id title due_date status created_at updated_at].freeze  

  def index
    @tasks = Task.all.order(created_at: :desc) 
    # @tasks = Task.all.order(created_at: :desc) if params[:sort_created_at]としない
    # 上記のようにすると、デフォルトページがどっちか指定できず、テストでエラーになる
    @tasks = Task.all.order(due_date: :desc) if params[:sort_due_date]
    @tasks = Task.all.order(priority: :asc) if params[:sort_priority]
    if params[:task].present?
      title = params[:task][:title]
      status = params[:task][:status]
      if title.present? && status.present?
        @tasks = Task.search_title_status(title, status)
      elsif title.present? 
        @tasks = Task.search_title(title)
      elsif status.present?
        @tasks = Task.search_status(status)
      end
    end
  end

  def new
    if params[:back]
      @task = Task.new(task_params)
    else
      @task = Task.new
    end
  end

  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if params[:back]
        render :new
      else
        if @task.save
          format.html { redirect_to task_url(@task), notice: "タスクが作成されました" }
          format.json { render :show, status: :created, location: @task }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: "タスクが更新されました" }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def destroy
    @task.destroy  
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "タスクが削除されました" }
      format.json { head :no_content }
    end
  end

  private

  def task_params
    params.require(:task).permit(:title, :content, :due_date, :created_at, :sort_expired, :search, :status, :priority)
    # params.require(:task).permit(:name, :description, :expiry_date, :created_at, :sort_expired, :search, :status, :priority, :page ).merge(priority: params[:task][:priority])
    # という書き方もあるようだが、差異についてはいまいちよくわからない
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
