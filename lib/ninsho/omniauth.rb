# Thanks to plataformatec for providing this 
begin
  require "omniauth"
  require 'omniauth/version'
rescue LoadError
  warn "Could not load 'omniauth'. Please ensure you have the omniauth gem >= 1.0.0 installed and listed in your Gemfile."
  raise
end

unless OmniAuth::VERSION =~ /^1\./
  raise "You are using an old OmniAuth version, please ensure you have 1.0.0.pr2 version or later installed."
end

module Ninsho 
  module OmniAuth
    autoload :Config, "ninsho/omniauth/config"
  end
end
