module SessionsHelper

def sign_in(user)
    un_remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = un_remember_token
    options = { :namespace => "sessionsvm", :compress => true }
    dallic = Dalli::Client.new
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
    remember_token = User.encrypt(cookies[:remember_token])
    options = { :namespace => "sessionsvm", :compress => true }
    dallic = Dalli::Client.new
    userid = dallic.get(User.encrypt(cookies[:remember_token]))
    @current_user ||= User.where(id: userid).first
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
