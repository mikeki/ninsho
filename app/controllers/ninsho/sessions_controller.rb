class Ninsho::SessionsController < NinshoController

  def new
    @providers = Ninsho.providers
  end

  def create
    resource = build_resource_from_omniauth
    if resource.authenticated?
      sign_in resource.user.id
      redirect_to_root
    else
      redirect_to_root
    end
  end

  def destroy
    sign_out 
    redirect_to_root
  end
end
