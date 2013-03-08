module Ninsho
  class Railtie < Rails::Railtie
    ActiveSupport.on_load :active_record do
      ActiveRecord::Base.send :include, Ninsho::Interface
    end
  end
end
