require 'ninsho/rails/routes'

module Ninsho
  class Engine < ::Rails::Engine
    config.ninsho = Ninsho

    # Force routes to be loaded if we are doing any eager load.
    config.before_eager_load { |app| app.reload_routes! }

    ActiveSupport.on_load(:action_controller) do
      include Ninsho::Controllers::Helpers 
    end

    initializer "ninsho.omniauth" do |app|
      Ninsho.omniauth_configs.each do |provider, config|
        app.middleware.use config.strategy_class, *config.args do |strategy|
          config.strategy = strategy
        end
      end
    end
  end
end
