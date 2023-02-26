class ApplicationController < ActionController::Base
  include SessionsHelper  
  protect_from_forgery with: :exception
  before_action :login_required
  before_action :set_current_user

  private
  def set_current_user
    @current_user = current_user
  end

  def login_required
    redirect_to new_session_path unless current_user 
  end

end
