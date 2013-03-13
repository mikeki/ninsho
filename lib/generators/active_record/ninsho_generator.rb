require 'rails/generators/active_record'
require 'generators/ninsho/orm_helpers'

module ActiveRecord
  module Generators
    class NinshoGenerator < ActiveRecord::Generators::Base
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      include Ninsho::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_ninsho_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "existing_migration.rb", "db/migrate/add_ninsho_to_#{table_name}"
        else
          migration_template "migration.rb", "db/migrate/ninsho_create_#{table_name}"
        end
      end

      def generate_model
        invoke "active_record:model", [name], :migration => false unless model_exists? && behavior == :invoke
      end

     def inject_ninsho_content
      content = <<CONTENT
  attr_accessible :provider, :uid
  # belongs_to_ninsho :user
CONTENT

      class_path = if namespaced?
        class_name.to_s.split("::")
      else
        [class_name]
      end

      indent_depth = class_path.size - 1
      content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"
      inject_into_class(model_path, class_path.last, content) if model_exists?
     end

       def migration_data
<<RUBY
      ## Ninsho model fields
      t.integer :user_id
      t.string :provider
      t.string :uid
RUBY
      end
    end
  end
end
