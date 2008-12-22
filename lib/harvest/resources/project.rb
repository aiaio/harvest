module Harvest
  module Resources
    # Supports the following:
    class Project < Harvest::HarvestResource
      include Harvest::Plugins::Toggleable
      
      def users
        user_class = Harvest::Resources::UserAssignment.clone
        user_class.project_id = self.id
        user_class
      end
      
      def tasks
        task_class = Harvest::Resources::TaskAssignment.clone
        task_class.project_id = self.id
        task_class
      end
      
      # Find all entries for the given project;
      # options[:from] and options[:to] are required;
      # include options[:user_id] to limit by a specific user.
      #   
      def entries(options={})
        validate_entries_options(options)
        entry_class = Harvest::Resources::Entry.clone
        entry_class.project_id = self.id
        entry_class.find :all, :params => format_params(options)
      end
      
      private
      
        def validate_entries_options(options)
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
          ops[:user_id] = options[:user_id] if options[:user_id]
          return ops
        end
          
    end
  end
end