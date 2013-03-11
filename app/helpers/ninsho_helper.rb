module NinshoHelper
  RESOURCE_NAME = Ninsho.resource_name.singularize
  PARENT_RESOURCE_NAME = Ninsho.parent_resource_name.to_s.downcase

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
    session["#{PARENT_RESOURCE_NAME}_id".to_sym] = nil 
  end

  def sign_in_and_redirect(parent_id, path=nil)
    session["#{PARENT_RESOURCE_NAME}_id".to_sym] = parent_id
    redirect_to path
  end

  def sign_in(parent_id)
    session["#{PARENT_RESOURCE_NAME}_id".to_sym] = parent_id
  end

  class_eval <<-METHODS, __FILE__, __LINE__ + 1
    def current_#{PARENT_RESOURCE_NAME}
      @current_#{PARENT_RESOURCE_NAME} ||= #{Ninsho.parent_resource_name}.find(session[:#{PARENT_RESOURCE_NAME}_id]) if session[:#{PARENT_RESOURCE_NAME}_id] 
    end

    def #{PARENT_RESOURCE_NAME}_signed_in?
      current_#{PARENT_RESOURCE_NAME}.present? 
    end

    def authenticate_#{PARENT_RESOURCE_NAME}!
      deny_access unless #{PARENT_RESOURCE_NAME}_signed_in?
    end

  METHODS

  define_method "link_#{RESOURCE_NAME}_with" do |provider|
    link_to "Connect with #{provider.to_s.capitalize}", "auth/#{provider.to_s}"
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
