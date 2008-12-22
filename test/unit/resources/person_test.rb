require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class PersonTest < Test::Unit::TestCase
  
  def setup_resources
    @person_xml  =  {:id => 1, :name => "Joe Coder"}.to_xml(:root => "person")
    @people      = [{:id => 1, :name => "Joe Coder"}].to_xml(:root => "people")
    @entry       = [{:id => 2, :project_id => 50}].to_xml(:root => "day-entries")
    @entries     = [{:id => 1, :project_id => "25"}, 
                    {:id => 2, :project_id => 50}  ].to_xml(:root => "day-entries")
    @expenses    = [{:id => 1, :project_id => "25"}, 
                    {:id => 2, :project_id => 50}  ].to_xml(:root => "expenses")
  end
  
  def mock_responses
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/people.xml",           {}, @people
      mock.get    "/people/1.xml",         {}, @person_xml
      mock.post   "/people.xml",           {}, @person_xml, 201, "Location" => "/people/5.xml"
      mock.put    "/people/1.xml",         {}, nil,     200
      mock.delete "/people/1.xml",         {}, nil,     200
      mock.put    "/people/1/toggle.xml",  {}, nil, 200
      mock.get    "/people/1/entries.xml?from=20080101&to=20080131", {}, @entries
      mock.get    "/people/1/entries.xml?from=20080101&project_id=3&to=20080131", {}, @entry
      mock.get    "/people/1/expenses.xml?from=20080101&to=20080131", {}, @expenses
    end
  end
  
  context "People CRUD actions -- " do 
    setup do 
      setup_resources
      mock_responses
    end
    
    should "get index" do 
      Harvest::Resources::Person.find(:all)
      expected_request = ActiveResource::Request.new(:get, "/people.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "get a single project" do 
      Harvest::Resources::Person.find(1)
      expected_request = ActiveResource::Request.new(:get, "/people/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "create a new project" do 
      project = Harvest::Resources::Person.new(:name => "Widgets&Co")
      project.save
      expected_request = ActiveResource::Request.new(:post, "/people.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "update an existing project" do 
      project = Harvest::Resources::Person.find(1)
      project.name = "Joe Coder"
      project.save
      expected_request = ActiveResource::Request.new(:put, "/people/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "delete an existing project" do 
      Harvest::Resources::Person.delete(1)
      expected_request = ActiveResource::Request.new(:delete, "/people/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
  end
  
    
  context "Toggling active/inactive status" do 
    setup do 
      setup_resources
      mock_responses
    end
    
    should "hit the toggle method" do
      person = Harvest::Resources::Person.find(1)
      person.toggle
      expected_request = ActiveResource::Request.new(:put, "/people/1/toggle.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "return 200 Success toggle method" do
      person = Harvest::Resources::Person.find(1)
      assert person.toggle.code == 200
    end
        
  end
  
  context "Getting entries" do 
    setup do 
      setup_resources
      mock_responses
      @person = Harvest::Resources::Person.find(1)
    end
    
    should "raise an error if start and end are not included" do 
      assert_raises ArgumentError, "Must specify :start and :end as dates." do  
        @person.entries
      end
    end
    
    should "raise an error if end date precedes start date" do 
      assert_raises ArgumentError, "Must specify :start and :end as dates." do  
        @person.entries(:from => Time.utc(2007, 1, 1), :to => Time.utc(2006, 1, 1))
      end
    end
    
    should "return the project site prefix" do
      entry_class = Harvest::Resources::Entry.clone
      entry_class.person_id = @person.id
      assert_equal "http://example.com/people/1", entry_class.site.to_s
    end
    
  end
  
  context "Reports -- " do   
    setup do
      setup_resources 
      mock_responses
      @from    = Time.utc(2008, 1, 1)
      @to      = Time.utc(2008, 1, 31)
      @person = Harvest::Resources::Person.find(1)
      @request_path = "/people/1/entries.xml?from=20080101&to=20080131"
      @expense_path = "/people/1/expenses.xml?from=20080101&to=20080131"
    end
      
    should "get all entries for a given date range" do
      @person.entries(:from => @from, :to => @to)
      expected_request = ActiveResource::Request.new(:get, @request_path)
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "get all entries for the given date range and user" do 
      path = "/people/1/entries.xml?from=20080101&project_id=3&to=20080131"
      @person.entries(:from => @from, :to => @to, :project_id => 3)
      expected_request = ActiveResource::Request.new(:get, path)
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "return all expense entries logged by the given user" do
      @person.expenses(:from => @from, :to => @to)
      expected_request = ActiveResource::Request.new(:get, @expense_path)
      p ActiveResource::HttpMock.requests
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
       
  end
      
end