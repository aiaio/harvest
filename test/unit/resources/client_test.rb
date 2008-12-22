require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class ClientTest < Test::Unit::TestCase
  
  def setup_resources
    @client  =  {:id => 1, :name => "Widgets&Co"}.to_xml(:root => "client")
    @clients = [{:id => 1, :name => "Widgets&Co"}].to_xml(:root => "clients") 
  end
  
  def mock_client_responses
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/clients.xml",          {}, @clients
      mock.get    "/clients/1.xml",        {}, @client
      mock.post   "/clients.xml",          {}, @client, 201, "Location" => "/clients/5.xml"
      mock.put    "/clients/1.xml",        {}, nil,     200
      mock.delete "/clients/1.xml",        {}, nil,     200
      mock.put    "/clients/1/toggle.xml", {}, nil, 200
    end
  end
  
  context "Client actions" do 
    setup do 
      setup_resources
      mock_client_responses
    end
    
    should "get index" do 
      Harvest::Resources::Client.find(:all)
      expected_request = ActiveResource::Request.new(:get, "/clients.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "get a single client" do 
      Harvest::Resources::Client.find(1)
      expected_request = ActiveResource::Request.new(:get, "/clients/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "create a new client" do 
      client = Harvest::Resources::Client.new(:name => "Widgets&Co")
      client.save
      expected_request = ActiveResource::Request.new(:post, "/clients.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "update an existing client" do 
      client = Harvest::Resources::Client.find(1)
      client.name = "Sprockets & Co"
      client.save
      expected_request = ActiveResource::Request.new(:put, "/clients/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "delete an existing client" do 
      Harvest::Resources::Client.delete(1)
      expected_request = ActiveResource::Request.new(:delete, "/clients/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
  end
    
  context "Toggling active/inactive status" do 
    setup do 
      setup_resources
      mock_client_responses
    end
    
    should "hit the toggle method" do
      client = Harvest::Resources::Client.find(1)
      client.toggle
      expected_request = ActiveResource::Request.new(:put, "/clients/1/toggle.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "return 200 Success toggle method" do
      client = Harvest::Resources::Client.find(1)
      assert client.toggle.code == 200
    end
        
  end
  
end