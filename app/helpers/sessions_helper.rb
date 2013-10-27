require 'dalli'
module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    options = { :namespace => "sessionsvm", :compress => true }
    dallic = Dalli::Client.new('sessionvm.0e6avx.0001.use1.cache.amazonaws.com:11211', options)
    dallic.set('remember_token' + remember_token, user.id)
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.where(remember_token: remember_token).first
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end



end
