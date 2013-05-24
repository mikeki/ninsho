module Ninsho
  # 
  # Responsible for manage the authentication process with the
  # omniauth hash 
  #
  class Authentication
     def initialize(omniauth = nil)
      @omniauth = omniauth
      @provider = omniauth['provider'] 
      @uid = omniauth['uid']
      @oauth_token = @omniauth.credentials.token
      @email = omniauth['info']['email']
     end

     def authenticated?
       user.present?
     end

     # Little method to check if the record is find by the provider and uid
     def from_oauth
       resource_class = Ninsho.resource_class.where(@omniauth.slice(:provider, :uid)).first_or_initialize
       resource_class.tap do |resource|
         resource.provider = @provider
         resource.uid = @uid
         resource.oauth_token = @oauth_token
         resource.save if resource.respond_to?(Ninsho.parent_resource_name.to_s.downcase.to_sym) && !resource.new_record?
       end
     end

     # Method to create an authentication record when user is find,
     # otherwise creates a user with the authentication
     def from_user
       attrs = { email: @email }
       user = Ninsho.parent_resource_name.where(attrs).first_or_initialize
       user.attributes = holding_attributes(attrs) if user.new_record?
       user.send("#{Ninsho.resource_name.pluralize}").build(provider: @provider, uid: @uid, oauth_token: @oauth_token)
       user.save
       user
     end

     # Check if a parent record is returned, commonly the User model
     def user
        from_oauth.try(Ninsho.parent_resource_name.to_s.downcase.to_sym) || from_user
     end

     #Holding user attributes
     def holding_attributes(attrs = {})
       Ninsho.parent_resource_holding_attributes.each do |attr|
         attrs[attr] = nested_hash_value(@omniauth, attr)
       end
       attrs
     end

     private

     # Recursive method to look for the key on the omniauth hash
     # and returns the value
     def nested_hash_value(obj,key)
       if obj.respond_to?(:key?) && obj.key?(key)
         obj[key]
       elsif obj.respond_to?(:each)
         r = nil
         obj.find{ |*a| r=nested_hash_value(a.last,key)  }
         r
       end
     end
  end
end
