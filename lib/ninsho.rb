require 'rails'
require "ninsho/version"
require 'orm_adapter'
require 'active_support/core_ext/numeric/time'
require 'active_support/dependencies'

module Ninsho

  autoload :OmniAuth, 'ninsho/omniauth'

  module Controllers
    autoload :Helpers, 'ninsho/controllers/helpers'
  end

  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  mattr_accessor :resource_class
  @@resource_class = ""

  mattr_accessor :resource_name
  @@resource_name = ""

  mattr_reader :providers
  @@providers = []

  mattr_accessor :parent_resource_name
  @@parent_resource_name = '' 


  mattr_reader :omniauth_configs
  @@omniauth_configs = ActiveSupport::OrderedHash.new
  
  def self.setup
    yield self
  end

  class Getter
    def initialize name
      @name = name
    end

    def get
      ActiveSupport::Dependencies.constantize(@name)
    end
  end

  def self.ref(arg)
    if defined?(ActiveSupport::Dependencies::ClassCache)
      ActiveSupport::Dependencies::reference(arg)
      Getter.new(arg)
    else
      ActiveSupport::Dependencies.ref(arg)
    end
  end

  def self.omniauth(provider, *args)
    config = Ninsho::OmniAuth::Config.new(provider, args)
    @@providers << config.strategy_name.to_sym
    @@omniauth_configs[config.strategy_name.to_sym] = config
  end

end

require 'ninsho/routes_drawer'
require 'ninsho/rails'
require 'ninsho/interface'
require 'ninsho/railtie'
