module Harvest
  module Resources
    class Expense < Harvest::HarvestResource
      
      self.element_name = "expense"
      
      class << self
      
        def person_id=(id)
          @person_id = id
          self.site = self.site + "/people/#{@person_id}"
        end
        
        def person_id
          @person_id
        end
        
      end
                  
    end
  end
end