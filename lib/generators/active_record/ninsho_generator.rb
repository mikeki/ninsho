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

       def migration_data
<<RUBY
      ## Database authentications 
      t.integer :user_id
      t.string :provider
      t.string :uid
RUBY
      end
    end
  end
end
