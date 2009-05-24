require 'csv'
module Harvest
  module Resources
    class Invoice < Harvest::HarvestResource
      self.element_name = 'invoice'

      def parsed_line_items
        headers = nil
        entries = []
        CSV::Reader.parse(csv_line_items) do |row|
          unless headers
            headers = row
          else
            entry = {}
            row.each_with_index{|c,i|entry[headers[i]] = c}
            entries << entry
          end
        end
        entries
      end

      class << self
        def find_by_number number
          i = find(:all).find{|i|i.number.to_s == number.to_s}
          find(i.id) if i
        end
      end
    end
  end
end
