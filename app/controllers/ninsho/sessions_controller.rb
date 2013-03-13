class Ninsho::SessionsController < NinshoController

  def new
    @providers = Ninsho.providers
  end

  # Handles the omniauth record creation
  def create
    resource = build_resource_from_omniauth
    if resource.authenticated?
      sign_in resource.send(Ninsho.parent_resource_name.to_s.downcase).id
      flash_message(:notice, :signed_in)
      redirect_on_sign_in_path
    else
      redirect_to_root
    end
  end

  def destroy
    sign_out 
    flash_message(:notice, :signed_out)
    redirect_on_sign_out_path
  end
end
