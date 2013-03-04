module Ninsho
  module Generators
    class NinshoGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      namespace "ninsho"
      desc "Creates a model with the given name with ninsho" <<
           "includes migration files, and routes config"

     hook_for :orm

     class_option :routes, :desc => "Generate routes", :type => :boolean, :default => true

     def add_ninsho_routes
       ninsho_routes = "ninsho_on :#{plural_name}"
       ninsho_routes << %Q(, :class_name => "#{class_name}") if class_name.include?("::")
       ninsho_routes << %Q(, :skip => :all) unless options.routes?
       route ninsho_routes
     end
    end
  end
end
