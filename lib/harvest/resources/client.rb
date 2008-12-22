module Harvest
  module Resources
    class Client < Harvest::HarvestResource
      include Harvest::Plugins::Toggleable
                  
    end
  end
end