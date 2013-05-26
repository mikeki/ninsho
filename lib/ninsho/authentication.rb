module Ninsho
  # 
  # Responsible for manage the authentication process with the
  # omniauth hash 
  #
  class Authentication
     def initialize(omniauth = nil, current_user = nil)
      @omniauth = omniauth
      @provider = omniauth['provider'] 
      @uid = omniauth['uid']
      @oauth_token = @omniauth.credentials.token
      @email = omniauth['info']['email']
      @current_user = current_user
     end

     def authenticated?
       user.present?
     end

     # Little method to check if the record is find by the provider and uid
     def from_oauth
       Ninsho.resource_class.where(@omniauth.slice(:provider, :uid)).first_or_initialize.tap do |resource|
         resource.provider = @provider
         resource.uid = @uid
         resource.oauth_token = @oauth_token
         resource.save if resource.respond_to?(Ninsho.parent_resource_name.to_s.downcase.to_sym) && !resource.new_record?
       end
     end

     # Method to create an authentication record when user is find,
     # otherwise creates a user with the authentication
     def from_user
       user = Ninsho.parent_resource_name.send :find_by_email, @email
       user = Ninsho.parent_resource_name.send :new, { email: @email } unless user
       user.send("#{Ninsho.resource_name.pluralize}").build(provider: @provider, uid: @uid, oauth_token: @oauth_token)
       user.send(:save)
       user
     end

     # Check if a parent record is returned
     def user
       @current_user || from_oauth.try(Ninsho.parent_resource_name.to_s.downcase.to_sym) || from_user
     end
  end
end
