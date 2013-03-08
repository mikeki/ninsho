class NinshoController < Ninsho.parent_controller.constantize

  
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
    params[resource_name]
  end

  # Proxy to devise map name
  def resource_name
    Ninsho.resource_name
  end

  def resource_class
    Ninsho.resource_class 
  end

  # Sets the resource creating an instance variable
  def resource=(new_resource)
    instance_variable_set(:"@#{resource_name}", new_resource)
  end

    # Build a devise resource.
  # Assignment bypasses attribute protection when :unsafe option is passed
  def build_resource(hash = nil, options = {})
      self.resource = resource_class.new(hash)
  end
end
