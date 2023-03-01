class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)
  # 以下の記述でソートを許可するカラム名を一覧で定義。
  # SORTABLE_FIELDS = %w[id title due_date status created_at updated_at].freeze  

  def index
    @tasks = current_user.tasks.order(created_at: :desc)
    # @tasks = Task.all.order(created_at: :desc)
    # @tasks = Task.all.order(created_at: :desc) if params[:sort_created_at]としない
    # 上記のようにすると、デフォルトページがどっちか指定できず、テストでエラーになる
    @tasks = current_user.tasks.sort_due_date if params[:sort_due_date]
    @tasks = current_user.tasks.sort_priority if params[:sort_priority]
    if params[:task].present?
      title = params[:task][:title]
      status = params[:task][:status]
      label_ids = params[:task][:label_ids]
      if title.present? && status.present?
        @tasks = current_user.tasks.search_title_status(title, status)
        # @tasks = Task.search_title_status(title, status)
      elsif title.present? 
        @tasks = current_user.tasks.search_title(title)
        # @tasks = Task.search_title(title)
      elsif status.present?
        @tasks = current_user.tasks.search_status(status)
        # @tasks = Task.search_status(status)
      elsif label_ids.present?
        @tasks = current_user.tasks.search_label(label_ids)
        # elsif label_ids.present?
        # @tasks = @tasks.joins(:labels).where(labels: { id: params[:label_id] })
      end
    end
    @tasks = @tasks.latest.page(params[:page])
  end

  def new
    if params[:back]
      @task = Task.new(task_params)
    else
      @task = Task.new
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    # @task = Task.new(task_params)たぶん↑の書き方の方が直感的にわかりやすい。
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
    params.require(:task).permit(:title, :content, :due_date, :search, :status, :priority, { label_ids: [] })
    # params.require(:task).permit(:name, :description, :expiry_date, :created_at, :sort_expired, :search, :status, :priority, :page ).merge(priority: params[:task][:priority])
    # という書き方もあるようだが、差異についてはいまいちよくわからない
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
