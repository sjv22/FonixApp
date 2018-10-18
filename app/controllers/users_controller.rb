class UsersController < ApplicationController
  before_action :reset_session
  skip_before_action :valid_user!

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] =  'You have created an account successfully. Please log in to continue.'
      redirect_to login_path
    else
      render :new
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
