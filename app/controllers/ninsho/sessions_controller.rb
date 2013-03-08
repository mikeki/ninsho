class Ninsho::SessionsController < NinshoController

  def new
    @providers = Ninsho.providers
  end

  def create
    resource = build_resource
    user = resource.send("build_#{parent_resource}".to_sym)
    if resource.save
      sign_in resource.reload.send("#{parent_resource}_id".to_sym)
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
