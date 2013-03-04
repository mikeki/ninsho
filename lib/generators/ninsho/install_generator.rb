require 'securerandom'

module Ninsho
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Ninsho initializer to your application."
      class_option :orm

      def copy_initializer
        template 'ninsho.rb', "config/initializers/ninsho.rb"
      end

    end
  end
end
