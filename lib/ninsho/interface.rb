require 'ninsho/authentication'

module Ninsho
  module Interface
    def self.included(base)
      base.extend(ClassMethods)
    end

    def auth_hash
      Ninsho.resource_class.auth_hash
    end

    module ClassMethods

      attr_accessor :auth_hash

      def belongs_to_ninsho(*args)
        options = args.extract_options!
        
        associations = args.collect(&:to_s).collect(&:downcase)
        association_keys = associations.collect { |association| "#{association}_id" } 

        #Set the belongs_to association by ActiveRecord
        associations.each do |associated_model|
          belongs_to associated_model.to_sym
          Ninsho.parent_resource_name = Ninsho.ref(associated_model.to_s.classify).get
        end
      end

      # Responsible for creating or find the record with the
      # omniauth hash
      def from_omniauth(omniauth = nil, current_user = nil)
        self.auth_hash = omniauth
        Ninsho::Authentication.new(omniauth, current_user)
      end
    end
  end
end
