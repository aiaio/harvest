module Harvest
  class Base
   
    # Requires a sub_domain, email, and password.
    # Specifying headers is optional, but useful for setting a user agent.
    def initialize(options={})
      options.assert_valid_keys(:email, :password, :sub_domain, :headers)
      options.assert_required_keys(:email, :password, :sub_domain)
      @email        = options[:email]
      @password     = options[:password]
      @sub_domain   = options[:sub_domain]
      @headers      = options[:headers]
      configure_base_resource
    end
    
    # Below is a series of proxies allowing for easy
    # access to the various resources.
    
    # Clients
    def clients
      Harvest::Resources::Client
    end
    
    # Expenses.
    def expenses
      Harvest::Resources::Expense
    end
    
    # Expense categories.
    def expense_categories
      Harvest::Resources::ExpenseCategory
    end
    
    # People.
    # Also provides access to time entries.
    def people
      Harvest::Resources::Person
    end
    
    # Projects.
    # Provides access to the assigned users and tasks
    # along with reports for entries on the project.
    def projects
      Harvest::Resources::Project
    end
    
    # Tasks.
    def tasks
      Harvest::Resources::Task
    end

    private
    
      # Configure resource base class so that 
      # inherited classes can access the api.
      def configure_base_resource
        HarvestResource.site     = "http://#{@sub_domain}.#{Harvest::ApiDomain}"
        HarvestResource.user     = @email
        HarvestResource.password = @password
        HarvestResource.headers.update(@headers) if @headers.is_a?(Hash)
        load_resources
      end
      
      # Load the class representing the various resources.
      def load_resources
        resource_path = File.join(File.dirname(__FILE__), "resources")
        Harvest.load_all_ruby_files_from_path(resource_path)
      end
                
  end
end