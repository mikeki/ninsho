require 'ninsho/rails/routes'

module Ninsho
  class Engine < ::Rails::Engine
    config.ninsho = Ninsho

    # Force routes to be loaded if we are doing any eager load.
    config.before_eager_load { |app| app.reload_routes! }
  end
end
