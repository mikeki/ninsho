module Ninsho
  class Authentication
     def initialize(omniauth = nil)
      @omniauth = omniauth
      @provider = omniauth['provider'] 
      @uid = omniauth['uid']
     end

     def authenticated?
       user.present?
     end

     def from_oauth
       Ninsho.resource_class.find_by_provider_and_uid(@provider, @uid) 
     end

     def from_user
       auth = Ninsho.resource_class.new(provider: @provider, uid: @uid) 
       auth.send("build_#{Ninsho.parent_resource_name.to_s.downcase}".to_sym)
       auth.send(:save)
       auth.send(Ninsho.parent_resource_name.to_s.downcase.to_sym)
     end

     def user
       from_oauth.try(Ninsho.parent_resource_name.to_s.downcase.to_sym) || from_user
     end
  end
end
