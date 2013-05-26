class NinshoController < Ninsho.parent_controller.constantize

  # Sets the flash message with :key, using I18n. 
  # Example (i18n locale file):
  #
  #   en:
  #     ninsho:
  #       :sessions
  #         signed_in: "Signed in successfully"
  #
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
    self.resource = resource_class.from_omniauth(resource_params, current_user)
  end

end
