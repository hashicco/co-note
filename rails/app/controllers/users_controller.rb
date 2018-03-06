class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to :root if current_user
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
    @user = User.find params[:id]
    unless @user == current_user
      redirect_to :root, alert: "invalid access." 
      return
    end
  end

  def update
    @user = User.find params[:id]
    unless @user == current_user
      redirect_to :root, alert: "invalid access." 
      return
    end

    if @user.update user_params
      redirect_to(:root, notice: 'User was successfully updated')
    else
      flash.now[:alert] = "Some errors occured"
      render :edit
    end
  end

  # ...
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
