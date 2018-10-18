class SessionsController < ApplicationController
  skip_before_action :valid_user!, except: [:destroy]

  def new
  end

  def create
    reset_session
    @user = User.find_by(email: session_params[:email])

    if @user && @user.authenticate(session_params[:password])
      session[:user_id] = @user.id
      flash[:success] = 'You have logged in successfully.'
      redirect_to root_path
    else
      flash[:error] = 'You have enterd invalid email or password. Please try again.'
      redirect_to login_path
    end
  end

  def destroy
    reset_session
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
