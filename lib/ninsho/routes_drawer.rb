module Ninsho
  # Responsible for handling ninsho mappings and routes configuration
  # The required value in ninsho_on is actually not used internally, but it's
  # inflected to find all other values.
  #
  #   map.ninsho_on :authentications
  #   mapping = Ninsho.mappings[authentication]
  #
  #   mapping.name #=> :authentication
  #   # is the scope used in controllers given in the route as :singular.
  #
  #   mapping.as   #=> "authentications"
  #   # how the mapping should be search in the path, given in the route as :as.
  #
  #   mapping.to   #=> Authentication
  #   # is the class to be loaded from routes, given in the route as :class_name.
  #
  class RoutesDrawer #:nodoc:
    attr_reader :singular_name, :klass, :resource

    def initialize(name)
      @resource = name.to_s
      @singular_name = name.to_s.singularize
      @klass = Ninsho.ref(@singular_name.classify)
    end

    # Gives the class the mapping points to.
    def to
      @klass.get
    end
  end
end
