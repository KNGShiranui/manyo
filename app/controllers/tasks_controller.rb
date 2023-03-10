class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)


  def index
    @tasks = current_user.tasks.order(created_at: :desc)
    @tasks = current_user.tasks.sort_due_date if params[:sort_due_date]
    @tasks = current_user.tasks.sort_priority if params[:sort_priority]
    if params[:task].present?
      title = params[:task][:title]
      status = params[:task][:status]
      label_ids = params[:task][:label_ids]
      if title.present? && status.present?
        @tasks = current_user.tasks.search_title_status(title, status)
        # @tasks = current_user.tasks.search_title_status(title, status).sort_due_date if params[:sort_due_date]
        # @tasks = current_user.tasks.search_title_status(title, status).sort_priority if params[:sort_priority]
        # @tasks = Task.search_title_status(title, status)
      elsif title.present? 
        @tasks = current_user.tasks.search_title(title)
      elsif status.present?
        @tasks = current_user.tasks.search_status(status)
      elsif label_ids.present?
        @tasks = current_user.tasks.search_label(label_ids)
        # @tasks = current_user.tasks.search_label(label_ids).sort_due_date if params[:sort_due_date]
        # @tasks = current_user.tasks.search_label(label_ids).sort_priority if params[:sort_priority]
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
    if params[:back]
      render :new
    else
      if @task.save
        redirect_to task_url(@task), notice: "タスクが作成されました"
      else
        render :new, status: :unprocessable_entity 
      end
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_url(@task), notice: "タスクが更新されました" 
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm
    @task = current_user.tasks.build(task_params)
    render :new if @task.invalid?  
  end

  def show
  end

  def destroy
    @task.destroy  
    redirect_to tasks_url, notice: "タスクが削除されました" 
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


