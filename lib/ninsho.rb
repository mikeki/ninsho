require 'rails'
require "ninsho/version"
require 'orm_adapter'

module Ninsho

  def self.setup
    yield self
  end
end

require 'ninsho/rails'
