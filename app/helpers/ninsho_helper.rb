module NinshoHelper

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil 
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default )
    clear_return_to 
  end

  def after_sign_in_path_for
    redirect_back_or redirect_to_root
  end

  def sign_out
    session[:user_id] = nil 
  end

  def sign_in_and_redirect(user_id, path=nil)
    session[:user_id] = user_id
    redirect_to path
  end

  def sign_in(user_id)
    session[:user_id] = user_id
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] 
  end

  def signed_in?
    current_user.present? 
  end

  def authenticate_user!
    deny_access unless signed_in?
  end

  # Method used by sessions controller to sign out a user. 
  # You can overwrite it in your ApplicationController
  #
  # By default it is the root_path.
  def after_sign_out_path_for
    redirect_to_root
  end

  def redirect_to_root
    redirect_to respond_to?(:root_path) ? root_path : "/"
  end

  def deny_access
    redirect_to_root
  end
end
