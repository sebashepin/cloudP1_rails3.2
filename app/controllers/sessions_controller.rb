class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.where(email: params[:session][:email].downcase).first
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
  
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end

