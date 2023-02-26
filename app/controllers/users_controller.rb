class UsersController < ApplicationController
  skip_before_action :login_required, only: %i(new create)
  before_action :set_user, only: %i(show edit update destroy)
  before_action :ensure_correct_user, only: %i(show edit update destroy)
  before_action :can_not_new, only: %i(new)
  
  def index
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id  # TODO:これ必要なのかな？
        # format.html { redirect_to user_path(session[:user_id]), notice: "ユーザー登録が完了しました" }
        format.html { redirect_to user_path(@user.id), notice: "ユーザー登録が完了しました" }
        # TODO:上の@user.idはsession[:user.id]にしないのか？
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  def edit
  end
  
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "ユーザー情報が更新されました。" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to new_session_path, notice: "ユーザー情報が削除されました" }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def ensure_correct_user
    @user = User.find_by(id: params[:id])
    if @user.id != current_user.id
      flash[:notice] = "権限がありません"
      redirect_to tasks_path
    end
  end

  def can_not_new
    redirect_to tasks_path if current_user.present?
  end
end
