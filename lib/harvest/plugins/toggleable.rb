# Adds toggability to a harvest resource.
module Harvest
  module Plugins
    module Toggleable
        
      def toggle
        put(:toggle)
      end
    
    end
  end
end