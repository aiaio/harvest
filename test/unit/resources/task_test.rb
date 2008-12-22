require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class TaskTest < Test::Unit::TestCase
  
  def setup_resources
    @task    =  {:id => 1, :name => "Admin"}.to_xml(:root => "task")
    @tasks   = [{:id => 1, :name => "Admin"}].to_xml(:root => "tasks") 
  end
  
  def mock_responses
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/tasks.xml",          {}, @tasks
      mock.get    "/tasks/1.xml",        {}, @task
      mock.post   "/tasks.xml",          {}, @task, 201, "Location" => "/tasks/5.xml"
      mock.put    "/tasks/1.xml",        {}, nil, 200
      mock.delete "/tasks/1.xml",        {}, nil, 200
      mock.put    "/tasks/1/toggle.xml", {}, nil, 200
    end
  end
  
  context "Task actions" do 
    setup do 
      setup_resources
      mock_responses
    end
    
    should "get index" do 
      Harvest::Resources::Task.find(:all)
      expected_request = ActiveResource::Request.new(:get, "/tasks.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "get a single task" do 
      Harvest::Resources::Task.find(1)
      expected_request = ActiveResource::Request.new(:get, "/tasks/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "create a new task" do 
      task = Harvest::Resources::Task.new(:name => "Admin")
      task.save
      expected_request = ActiveResource::Request.new(:post, "/tasks.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "update an existing task" do 
      task = Harvest::Resources::Task.find(1)
      task.name = "Admin"
      task.save
      expected_request = ActiveResource::Request.new(:put, "/tasks/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "delete an existing task" do 
      Harvest::Resources::Task.delete(1)
      expected_request = ActiveResource::Request.new(:delete, "/tasks/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
  end
    
  context "Toggling active/inactive status" do 
    setup do 
      setup_resources
      mock_responses
    end
    
    should "hit the toggle method" do
      task = Harvest::Resources::Task.find(1)
      task.toggle
      expected_request = ActiveResource::Request.new(:put, "/tasks/1/toggle.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "return 200 Success toggle method" do
      task = Harvest::Resources::Task.find(1)
      assert task.toggle.code == 200
    end
        
  end
  
end