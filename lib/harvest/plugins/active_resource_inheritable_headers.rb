# Allows headers in an ActiveResource::Base class
# to be inherited by subclasses.  Useful for setting
# a User-Agent used by all resources.
module Harvest
  module Plugins
    module ActiveResourceInheritableHeaders
        
      module ClassMethods
        
        # If headers are not defined in a
        # given subclass, then obtain headers
        # from the superclass.
        def inheritable_headers
          if defined?(@headers)
            @headers
          elsif superclass != Object && superclass.headers
            superclass.headers
          else
            @headers ||= {}
          end
        end
        
      end
      
      def self.included(klass)
        klass.instance_eval do
          klass.extend ClassMethods
          class << self
            alias_method :headers, :inheritable_headers
          end
        end
      end
    
    end
  end
end