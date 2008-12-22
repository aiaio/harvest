module Harvest
  module Resources
    class Task < Harvest::HarvestResource
      include Harvest::Plugins::Toggleable
                  
    end
  end
end