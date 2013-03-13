module Ninsho 
  module Generators
    # Include this module in your generator to generate Ninsho views.
    # `copy_views` is the main method and by default copies all views
    module ViewPathTemplates #:nodoc:
      extend ActiveSupport::Concern

      included do
        argument :scope, :required => false, :default => nil,
                         :desc => "The scope to copy views to"

        public_task :copy_views
      end

      def copy_views
        view_directory :sessions
      end

      protected

      def view_directory(name, _target_path = nil)
        directory name.to_s, _target_path || "#{target_path}/#{name}" do |content|
          content
        end
      end

      def target_path
        @target_path ||= "app/views/ninsho"
      end
    end


    class DefaultGenerator < Rails::Generators::Base #:nodoc:
      include ViewPathTemplates
      source_root File.expand_path("../../../../app/views/ninsho", __FILE__)
      desc "Copies default Ninsho views to your application."
    end

    class ViewsGenerator < Rails::Generators::Base
      desc "Copies Ninsho views to your application."

      argument :scope, :required => false, :default => nil,
                       :desc => "The scope to copy views to"

      invoke DefaultGenerator 
    end
  end
end

