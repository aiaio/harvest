module Harvest
  # This is the base class from which all resource
  # classes inherit. Site and authentication params
  # are loaded into this class when a Harvest::Base
  # object is initialized.
  class HarvestResource < ActiveResource::Base
    include ActiveResourceThrottle
    include Harvest::Plugins::ActiveResourceInheritableHeaders
    
    # The harvest api will block requests in excess
    # of 40 / 15 seconds. Adds a throttle (with cautious settings). 
    # Throttle feature provided by activeresource_throttle gem.
    self.throttle(:requests => 30, :interval => 15, :sleep_interval => 60)
  end
end