require 'dalli'
class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.where(email: params[:session][:email].downcase).first
    # if user && user.id=retrieved_userid
    if user && user.password == params[:session][:password]
      options = { :namespace => "sessionsvm", :compress => true }
      dallic = Dalli::Client.new('sessionvm.0e6avx.0001.use1.cache.amazonaws.com:11211', options)
      retrieved_userid = dallic.get(user.remember_token)
      puts "*------------------------ I got "
      puts retrieved_userid
      puts " from dallic.get--------------*"
  
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
    options = { :namespace => "sessionsvm", :compress => true }
    dallic = Dalli::Client.new('sessionvm.0e6avx.0001.use1.cache.amazonaws.com:11211', options)
    dallic.delete(self.current_user.remember_token)
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end

