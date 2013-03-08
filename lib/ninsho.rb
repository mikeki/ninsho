require 'rails'
require "ninsho/version"
require 'orm_adapter'
require 'active_support/core_ext/numeric/time'
require 'active_support/dependencies'

module Ninsho

  # The parent controller all Devise controllers inherits from.
  # Defaults to ApplicationController. This should be set early
  # in the initialization process and should be set to a string.
  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  mattr_accessor :resource_class
  @@resource_class = ""

  mattr_accessor :resource_name
  @@resource_name = ""
  
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

end

require 'ninsho/routes_drawer'
require 'ninsho/rails'
