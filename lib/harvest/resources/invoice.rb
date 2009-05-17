module Harvest
  module Resources
    class Invoice < Harvest::HarvestResource
      self.element_name = 'invoice'

      class << self
        def find_by_number number
          find(find(:all).detect{|i|i.number == number}.id)
        end
      end
    end
  end
end
