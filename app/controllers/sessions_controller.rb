require 'dalli'
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.where(email: params[:session][:email].downcase).first
    if user
    #if user && user.authenticate(params[:session][:password])
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
    id=self.current_user.id
    dallic = Dalli::Client.new('sessionvm.0e6avx.0001.use1.cache.amazonaws.com:11211', options)
    dallic.delete('remember_token' + remember_token)
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end

