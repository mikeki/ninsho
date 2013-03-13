module Ninsho
  # Responsible for handling ninsho mappings and routes configuration
  # The required value in ninsho_on is actually not used internally, but it's
  # inflected to find all other values.
  #
  # routes_drawer.to #=> Authentication
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
