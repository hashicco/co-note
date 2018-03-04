class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to(login_path, notice: 'User was successfully created')
    else
      flash.now[:alert] = "Some errors occured"
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.new user_params
    if @user.save
      redirect_to(:root, notice: 'User was successfully updated')
    else
      flash.now[:alert] = "Some errors occured"
      render :new
    end
  end

  # ...
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
