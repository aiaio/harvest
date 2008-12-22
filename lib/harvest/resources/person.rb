module Harvest
  module Resources
    class Person < Harvest::HarvestResource
      include Harvest::Plugins::Toggleable
      
      # Find all entries for the given person;
      # options[:from] and options[:to] are required;
      # include options[:user_id] to limit by a specific project.
      def entries(options={})
        validate_options(options)
        entry_class = Harvest::Resources::Entry.clone
        entry_class.person_id = self.id
        entry_class.find :all, :params => format_params(options)
      end
      
      def expenses(options={})
        validate_options(options)
        expense_class = Harvest::Resources::Expense.clone
        expense_class.person_id = self.id
        expense_class.find :all, :params => format_params(options)
      end
      
      private
      
        def validate_options(options)
          if [:from, :to].any? {|key| !options[key].respond_to?(:strftime) }
            raise ArgumentError, "Must specify :from and :to as dates."
          end
          
          if options[:from] > options[:to]
            raise ArgumentError, ":start must precede :end."
          end
        
        end
        def format_params(options)
          ops = { :from => options[:from].strftime("%Y%m%d"),
                  :to   => options[:to].strftime("%Y%m%d")}
          ops[:project_id] = options[:project_id] if options[:project_id]
          return ops
        end
      
    end
  end
end