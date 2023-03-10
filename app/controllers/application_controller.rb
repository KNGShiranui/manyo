class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  # before_action :current_user

  private
  def authenticate_user!
    redirect_to new_session_path unless current_user 
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
    # セッションログインしているユーザーと、アクセスしようとしているページの作成者（ユーザー）が一致するか照合するための前工程
    # session[:user_id]がnilならnew_session_pathへリダイレクトされる
    # この過程はセッションのnewとcreateアクションには適用されない
    # current_userがアクセス権限のある人かどうかはensure_correct_userで確認される。
  end

  def logged_in?
    @current_user.present?
  end
  helper_method :current_user, :logged_in?
  # helper_method :current_userを記載しないとapplication_controllerに記載していてもcurrent_userメソッドをローカル変数の
  # ようにuserのshowページで用いることはできない。
  # というのも、helperはビューに適用されるのが前提だが、controllerに記載されているメソッドはそのままではビューで使用するという
  # 前提で設計されていない。使用するには上記のようにしてビューでもhelperとして使うと明示する必要あり
end