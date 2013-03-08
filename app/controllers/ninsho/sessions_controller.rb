class Ninsho::SessionsController < NinshoController

  def new
    @providers = Ninsho.providers
  end

  def create
    resource = build_resource
    user = resource.build_user
    if resource.save
      sign_in resource.user_id
      redirect_to_root
    else
      redirect_to_root
    end
  end

  def destroy
    sign_out 
    flash_message :success, 'Sign out successfully'
  end
end
