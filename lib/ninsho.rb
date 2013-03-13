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

  # The parent controller all Ninsho controllers inherits from.
  # The Default is set to ApplicationController.
  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  # The name class of the resource generate by the Ninsho model generator
  # Comonly Authentication
  mattr_accessor :resource_class
  @@resource_class = ""

  # The resource name singularized and downcased
  # Used as a proxy to map ninsho resource
  # Used in routes on ninsho_on method
  mattr_accessor :resource_name
  @@resource_name = ""

  # List all providers added in the initializer
  # All of them are symbols
  # [ :facebook, :twitter, :github ]
  mattr_reader :providers
  @@providers = []

  # The class name for the resource relation
  # Is commonly the class User
  mattr_accessor :parent_resource_name
  @@parent_resource_name = '' 

  # Hash which contains omniauth configurations
  mattr_reader :omniauth_configs
  @@omniauth_configs = ActiveSupport::OrderedHash.new
  
  # Default setup for Ninsho. 
  # Run the rails g ninsho:install to create a fresh initializer
  def self.setup
    yield self
  end

  # It is used toe get the resource class and map it with
  # ActiveSupport to get the class name
  # :user will become User
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

  # Used to specify an omniauth provider
  #
  #   config.omniauth :facebook, 'APPD_ID', 'APP_SECRET'
  #
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
