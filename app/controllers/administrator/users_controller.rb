class Administrator::UsersController < ApplicationController
  # skip_before_action :login_required
  before_action :set_user, only: %i(edit update show destroy)
  before_action :administrator
  def index
    @users = User.all.includes(:tasks).order(created_at: :desc)
    # n+1問題解消策
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      redirect_to administrator_users_path, notice: 'ユーザを作成'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update 
    if @user.update(user_params)
      redirect_to administrator_users_path, notice: 'ユーザを更新'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to administrator_users_path, notice: 'ユーザを削除'
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :administrator, :nonadministrator)
  end

  def set_user
    @user = User.find(params[:id])
  end
  
  def administrator
    if current_user.present?
      unless current_user.administrator?
        redirect_to tasks_path, notice: "許可されていません"
      # 現在のユーザーのadministratorカラムがtrueかどうかを確認。
      end
    end
  end
end
