class NinshoController < Ninsho.parent_controller.constantize

  include NinshoHelper  
  helpers = %w(resource resource_name resource_class resource_params)
  hide_action *helpers
  helper_method *helpers

  def flash_message(key, message) 
    flash[key] = message 
  end

  # Gets the actual resource stored in the instance variable
  def resource
    instance_variable_get(:"@#{resource_name}")
  end

  def resource_params
    env['omniauth.auth']
  end

  # Proxy to ninsho map name
  def resource_name
    Ninsho.resource_name #authentication
  end

  def resource_class
    Ninsho.resource_class 
  end

  # Sets the resource creating an instance variable
  def resource=(new_resource)
    instance_variable_set(:"@#{resource_name}", new_resource)
  end

  # Parent resource
  def parent_resource
    resource_class.reflect_on_all_associations(:belongs_to).first.name.to_s
  end

  # Build a ninsho resource.
  # Assignment bypasses attribute protection when :unsafe option is passed
  def build_resource_from_omniauth 
      self.resource = resource_class.from_omniauth(resource_params)
  end
end
