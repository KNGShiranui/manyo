class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end
  
  def destroy
    log_out
    redirect_to new_session_path, notice:  "ログアウトしました"
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
  end
end