require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class ExpenseCategoryTest < Test::Unit::TestCase
  
  def setup_resources
    @expense_category   =  {:id => 1, :name => "Mileage"}.to_xml(:root => "expense_category")
    @expense_categories = [{:id => 1, :name => "Mileage"}].to_xml(:root => "expense_categories") 
  end
  
  def mock_responses
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get    "/expense_categories.xml",          {}, @expense_categories
      mock.post   "/expense_categories.xml",          {}, @expence_categories, 201, "Location" => "/expense_categories/5.xml"
      mock.put    "/expense_categories/1.xml",        {}, nil,     200
      mock.delete "/expense_categories/1.xml",        {}, nil,     200
    end
  end
  
  context "expense_category actions" do 
    setup do 
      setup_resources
      mock_responses
    end
    
    # Note: The api technically supports updates; however, it doesn't support a show and
    # therefore doesn't work well with activeresource.
    
    should "get index" do 
      Harvest::Resources::ExpenseCategory.find(:all)
      expected_request = ActiveResource::Request.new(:get, "/expense_categories.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
  
    should "create a new expense_category" do 
      expense_category = Harvest::Resources::ExpenseCategory.new(:name => "Widgets&Co")
      expense_category.save
      expected_request = ActiveResource::Request.new(:post, "/expense_categories.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
    should "delete an existing expense_category" do 
      Harvest::Resources::ExpenseCategory.delete(1)
      expected_request = ActiveResource::Request.new(:delete, "/expense_categories/1.xml")
      assert ActiveResource::HttpMock.requests.include?(expected_request)
    end
    
  end
      
end