module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

def logged_in?
  @current_user.present?
end

# def administrator?
#   @current_user.administrator == true
# end
# 書かなくても定義されてるものだった・・・これをかくことでむしろエラーが出た・・・
end
