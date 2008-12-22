require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class UserAssignmentTest < Test::Unit::TestCase

  def setup_resources
    @user_assignment    =  {:id => 1, :project_id => 5}.to_xml(:root => "user_assignment")
    @user_assignments   = [{:id => 1, :project_id => 5}].to_xml(:root => "user_assignments") 
  end
  
  def mock_responses
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/user_assignments.xml",          {}, @user_assignments
      mock.get    "/user_assignments/1.xml",        {}, @user_assignment
      mock.post   "/user_assignments.xml",          {}, @user_assignment, 201, "Location" => "/user_assignments/5.xml"
      mock.put    "/user_assignments/1.xml",        {}, nil, 200
      mock.delete "/user_assignments/1.xml",        {}, nil, 200
      mock.put    "/user_assignments/1/toggle.xml", {}, nil, 200
    end
  end
  
  context "user_assignment actions" do 
    setup do 
      setup_resources
      mock_responses
    end
    
    should "get index" do 
      Harvest::Resources::UserAssignment.find(:all)
      expected_request = ActiveResource::Request.new(:get, "/user_assignments.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "get a single user_assignment" do 
      Harvest::Resources::UserAssignment.find(1)
      expected_request = ActiveResource::Request.new(:get, "/user_assignments/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "create a new user_assignment" do 
      user_assignment = Harvest::Resources::UserAssignment.new(:project_id => 5)
      user_assignment.save
      expected_request = ActiveResource::Request.new(:post, "/user_assignments.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "update an existing user_assignment" do 
      user_assignment = Harvest::Resources::UserAssignment.find(1)
      user_assignment.name = "Admin"
      user_assignment.save
      expected_request = ActiveResource::Request.new(:put, "/user_assignments/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "delete an existing user_assignment" do 
      Harvest::Resources::UserAssignment.delete(1)
      expected_request = ActiveResource::Request.new(:delete, "/user_assignments/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
  end

  context "UserAssignment class" do 
    
    should "adjust the site setting when the project_id is set" do 
      user_class = Harvest::Resources::UserAssignment.clone
      user_class.project_id = 5
      assert_equal "http://example.com/projects/5", user_class.site.to_s
    end
    
  end
end