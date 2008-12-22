require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class ExpenseAssignmentTest < Test::Unit::TestCase

  def setup_resources
    @task_assignment    =  {:id => 1, :project_id => 5}.to_xml(:root => "task_assignment")
    @task_assignments   = [{:id => 1, :project_id => 5}].to_xml(:root => "task_assignments") 
  end
  
  def mock_responses
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/task_assignments.xml",          {}, @task_assignments
      mock.get    "/task_assignments/1.xml",        {}, @task_assignment
      mock.post   "/task_assignments.xml",          {}, @task_assignment, 201, "Location" => "/task_assignments/5.xml"
      mock.put    "/task_assignments/1.xml",        {}, nil,     200
      mock.delete "/task_assignments/1.xml",        {}, nil,     200
      mock.put    "/task_assignments/1/toggle.xml", {}, nil, 200
    end
  end
  
  context "task_assignment actions" do 
    setup do 
      setup_resources
      mock_responses
    end
    
    should "get index" do 
      Harvest::Resources::TaskAssignment.find(:all)
      expected_request = ActiveResource::Request.new(:get, "/task_assignments.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "get a single task_assignment" do 
      Harvest::Resources::TaskAssignment.find(1)
      expected_request = ActiveResource::Request.new(:get, "/task_assignments/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "create a new task_assignment" do 
      task_assignment = Harvest::Resources::TaskAssignment.new(:project_id => 5)
      task_assignment.save
      expected_request = ActiveResource::Request.new(:post, "/task_assignments.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "update an existing task_assignment" do 
      task_assignment = Harvest::Resources::TaskAssignment.find(1)
      task_assignment.name = "Admin"
      task_assignment.save
      expected_request = ActiveResource::Request.new(:put, "/task_assignments/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "delete an existing task_assignment" do 
      Harvest::Resources::TaskAssignment.delete(1)
      expected_request = ActiveResource::Request.new(:delete, "/task_assignments/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
  end

  context "TaskAssignment class" do 
    
    should "adjust the site setting when the project_id is set" do 
      task_class = Harvest::Resources::TaskAssignment.clone
      task_class.project_id = 5
      assert_equal "http://example.com/projects/5", task_class.site.to_s
    end
    
  end
  
end