
module ActionDispatch::Routing
  

  class Mapper
    #Includes the ninsho_on method for routes. This method is responsible
    # for creating all the routes needed.
    #
    # == Example
    #
    # Assuming you have an authentications model on your application,
    # your routes should look like:
    #
    #   ninsho_on :authentications
    #   
    #   This method will generate something like:
    #
    #   Session routes
    #   new_authentication_session_path GET /sign_in { controller: 'ninsho/sessions', action: 'new' }
    #       authentication_session_path POST /authentication/:provider/callback { controller: 'ninsho/sessions', action: 'create' }
    #   destroy_authentication_session_path DELETE /sign_out { controller: 'ninsho/sessions', action: 'destroy' }
    #

     def ninsho_on(resources_name)
       drawer = Ninsho::RoutesDrawer.new resources_name
       Ninsho.resource_class = drawer.to
       Ninsho.resource_name = drawer.resource
       ninsho_session(drawer.singular_name)
     end

     protected

     def ninsho_session(name) #:nodoc:
       resource :session, :only => [], :controller => 'ninsho/sessions', :path => "" do
       get :new, :path => 'sign_in', as: "new_#{name}"
       get :create, path: '/:provider/callback', as: "#{name}"
       delete :destroy, path: 'sign_out', as: "destroy_#{name}"
     end
     end
  end
end
