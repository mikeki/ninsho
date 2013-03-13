class NinshoController < Ninsho.parent_controller.constantize

  helpers = %w(resource resource_name resource_class resource_params)
  hide_action *helpers
  helper_method *helpers

  def flash_message(key, action) 
    message = I18n.t("ninsho.sessions.#{action}")
    flash[key] = message if message.present?
  end

  # Gets the actual resource stored in the instance variable
  def resource
    instance_variable_get(:"@#{resource_name}")
  end

  # Omniauth hash for creating the records
  def resource_params
    env['omniauth.auth']
  end

  # Proxy to ninsho map name
  def resource_name
    Ninsho.resource_name #authentication
  end

  # Class name for the ninsho model
  # commonly Authentication
  def resource_class
    Ninsho.resource_class 
  end

  # Sets the resource creating an instance variable
  def resource=(new_resource)
    instance_variable_set(:"@#{resource_name}", new_resource)
  end

  # Parent resource, commonly user
  def parent_resource
    resource_class.reflect_on_all_associations(:belongs_to).first.name.to_s
  end

  # Build a ninsho resource, from the omniauth hash
  def build_resource_from_omniauth 
      self.resource = resource_class.from_omniauth(resource_params)
  end
end
