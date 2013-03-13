module Ninsho
  # Responsible for loading and mounting the Ninsho::Interface method on
  # ActiveRecord, which allows it to add the belongs_to_ninsho method
  # inside models
  class Railtie < Rails::Railtie
    ActiveSupport.on_load :active_record do
      ActiveRecord::Base.send :include, Ninsho::Interface
    end
  end
end
