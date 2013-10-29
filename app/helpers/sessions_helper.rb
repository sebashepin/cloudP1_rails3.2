require 'dalli'
module SessionsHelper

  def sign_in(user)
    un_remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = un_remember_token
    options = { :namespace => "sessionsvm", :compress => true }
    dallic = Dalli::Client.new('sessionvm.0e6avx.0001.use1.cache.amazonaws.com:11211', options)
    encrypted = User.encrypt(un_remember_token)
    dallic.set(encrypted, user.id)
    user.update_attribute(:remember_token, encrypted)
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    #remember_token = User.encrypt(cookies[:remember_token])
    options = { :namespace => "sessionsvm", :compress => true }
    dallic = Dalli::Client.new('sessionvm.0e6avx.0001.use1.cache.amazonaws.com:11211', options)
    userid = dallic.get(User.encrypt(cookies[:remember_token]))
    @current_user ||= User.where(id: userid).first
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
