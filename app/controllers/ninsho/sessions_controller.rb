class Ninsho::SessionsController < NinshoController

  def new
    @resource = build_resource(nil, unsafe: true) 
  end

  def create
    
  end

  def destroy
    sign_out 
    flash_message :success, 'Sign out successfully'
  end
end
