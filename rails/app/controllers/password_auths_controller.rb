class PasswordAuthsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]
  
  def new
    redirect_to :root if current_user
    @password_auth = PasswordAuth.new
  end

  def create
    @password_auth = PasswordAuth.new password_auth_params
    if @user = login(@password_auth.email, @password_auth.password)
      redirect_back_or_to(:root, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:root, notice: 'Logged out!')
  end

  private
  def password_auth_params
    params.require(:password_auth).permit( :email, :password )

  end


end
