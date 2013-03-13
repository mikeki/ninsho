module Ninsho
  # 
  # Responsible for manage the authentication process with the
  # omniauth hash 
  #
  class Authentication
    PARENT_RESOURCE_NAME = Ninsho.parent_resource_name.to_s.downcase

     def initialize(omniauth = nil)
      @omniauth = omniauth
      @provider = omniauth['provider'] 
      @uid = omniauth['uid']
      @email = omniauth['info']['email']
     end

     def authenticated?
       user.present?
     end

     # Little method to check if the record is find by the provider and uid
     def from_oauth
       Ninsho.resource_class.find_by_provider_and_uid(@provider, @uid) 
     end

     # Method to create an authentication record when user is find,
     # otherwise creates a user with the authentication
     def from_user
       user = Ninsho.parent_resource_name.send :find_by_email, @email
       if user
         user.send("#{Ninsho.resource_name.pluralize}").build(provider: @provider, uid: @uid)
         user.send(:save)
         user
       else
         user = Ninsho.parent_resource_name.send :new, { email: @email }
         user.send("#{Ninsho.resource_name.pluralize}").build(provider: @provider, uid: @uid)
         user.send(:save)
         user
       end
     end

     # Check if a parent record is returned
     def user
       from_oauth.try(Ninsho.parent_resource_name.to_s.downcase.to_sym) || from_user
     end
  end
end
