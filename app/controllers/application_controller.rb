class ApplicationController < ActionController::Base
	before_action :valid_user!

  def current_user
    if !session[:user_id].blank?
      @user ||= User.find(session[:user_id])
    end
  end

  def valid_user!
    if current_user.nil?
      flash[:error] = 'Please log in to access Fonix API Dashboard!'
      redirect_to login_path
    end
  end
end
