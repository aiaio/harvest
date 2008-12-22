require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class ProjectTest < Test::Unit::TestCase
  
  def setup_resources
    @project_xml = {:id => 1, :name => "Widget Redesign"}.to_xml(:root => "project")
    @projects    = [{:id => 1, :name => "Widget Redesign"}].to_xml(:root => "projects")
    @entry       = [{:id => 2, :project_id => 50}].to_xml(:root => "day-entries")
    @entries     = [{:id => 1, :project_id => "25"}, 
                    {:id => 2, :project_id => 50}].to_xml(:root => "day-entries")
    @user_assignment = {:id => 1, :user_id => 5}.to_xml(:root => "user-assignment")
  end
  
  def mock_responses
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/projects.xml",           {}, @projects
      mock.get    "/projects/1.xml",         {}, @project_xml
      mock.post   "/projects.xml",           {}, @project, 201, "Location" => "/projects/5.xml"
      mock.put    "/projects/1.xml",         {}, nil,     200
      mock.delete "/projects/1.xml",         {}, nil,     200
      mock.put    "/projects/1/toggle.xml",  {}, nil, 200
      mock.get    "/projects/1/entries.xml?from=20080101&to=20080131",           {}, @entries
      mock.get    "/projects/1/entries.xml?from=20080101&to=20080131&user_id=3", {}, @entry
    end
  end
  
  context "Project CRUD actions -- " do 
    setup do 
      setup_resources
      mock_responses
    end
    
    should "get index" do 
      Harvest::Resources::Project.find(:all)
      expected_request = ActiveResource::Request.new(:get, "/projects.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "get a single project" do 
      Harvest::Resources::Project.find(1)
      expected_request = ActiveResource::Request.new(:get, "/projects/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "create a new project" do 
      project = Harvest::Resources::Project.new(:name => "Widgets&Co")
      project.save
      expected_request = ActiveResource::Request.new(:post, "/projects.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "update an existing project" do 
      project = Harvest::Resources::Project.find(1)
      project.name = "Sprockets & Co"
      project.save
      expected_request = ActiveResource::Request.new(:put, "/projects/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "delete an existing project" do 
      Harvest::Resources::Project.delete(1)
      expected_request = ActiveResource::Request.new(:delete, "/projects/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
  end
  
  context "Toggling active/inactive status" do 
    setup do 
      setup_resources
      mock_responses
    end
    
    should "hit the toggle method" do
      project = Harvest::Resources::Project.find(1)
      project.toggle
      expected_request = ActiveResource::Request.new(:put, "/projects/1/toggle.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "return 200 Success toggle method" do
      project = Harvest::Resources::Project.find(1)
      assert project.toggle.code == 200
    end
        
  end
    
  context "Nesting " do
    setup do 
      setup_resources
      mock_responses
      @project = Harvest::Resources::Project.find(1) 
    end
    
    should "get user assignments" do 
      end
    
    should "get task assignments" do 
    end
     
  end
  
  context "Listing entries" do 
    setup do
      setup_resources
      mock_responses
      @project = Harvest::Resources::Project.find(1)
    end
    
    should "raise an error if start and end are not included" do 
      assert_raises ArgumentError, "Must specify :start and :end as dates." do  
        @project.entries
      end
    end
    
    should "raise an error if end date precedes start date" do 
      assert_raises ArgumentError, "Must specify :start and :end as dates." do  
        @project.entries(:from => Time.utc(2007, 1, 1), :to => Time.utc(2006, 1, 1))
      end
    end
    
    should "return the project site prefix" do
      entry_class = Harvest::Resources::Entry.clone
      entry_class.project_id = @project.id
      assert_equal "http://example.com/projects/1", entry_class.site.to_s
    end
  
  end
    
  context "Reports -- " do   
    setup do
      setup_resources 
      mock_responses
      @from    = Time.utc(2008, 1, 1)
      @to      = Time.utc(2008, 1, 31)
      @project = Harvest::Resources::Project.find(1)
      @request_path = "/projects/1/entries.xml?from=20080101&to=20080131"
    end
      
    should "get all entries for a given date range" do
      @project.entries(:from => @from, :to => @to)
      expected_request = ActiveResource::Request.new(:get, @request_path)
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "get all entries for the given date range and user" do 
      @project.entries(:from => @from, :to => @to, :user_id => 3)
      expected_request = ActiveResource::Request.new(:get, @request_path + "&user_id=3")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
       
  end
  
end