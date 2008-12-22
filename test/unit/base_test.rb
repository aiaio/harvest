require File.join(File.dirname(__FILE__), "..", "test_helper")

class BaseTest < Test::Unit::TestCase
    
  context "A Harvest object" do 
    setup do 
      @password   = "secret"
      @email      = "james@example.com"
      @sub_domain = "bond"
      @headers    = {"User-Agent" => "HarvestGemTest"}
      @harvest    = Harvest::Base.new(:email      => @email, 
                                      :password   => @password, 
                                      :sub_domain => @sub_domain,
                                      :headers    => @headers)
    end
    
    should "initialize the resource base class" do
      assert_equal "http://bond.harvestapp.com", Harvest::HarvestResource.site.to_s
      assert_equal @password, Harvest::HarvestResource.password
      assert_equal @email,    Harvest::HarvestResource.user
    end
        
    should "raise an error if sub_domain is missing" do
      assert_raise_plus ArgumentError, "Missing required option(s): sub_domain" do
        Harvest(:email => "joe@example.com", :password => "secret")
      end
    end
    
    should "raise an error if password is missing" do
      assert_raise_plus ArgumentError, "Missing required option(s): password" do
        Harvest(:email => "joe@example.com", :sub_domain => "time")
      end
    end
    
    should "raise an error if email is missing" do
      assert_raise_plus ArgumentError, "Missing required option(s): email" do
        Harvest(:password => "secret", :sub_domain => "time")
      end
    end
    
    should "set the headers" do
      assert_equal @headers, Harvest::HarvestResource.headers
    end
    
    should "return the Client class" do
      assert_equal Harvest::Resources::Client, @harvest.clients
    end
    
    should "return the Expense class" do
      assert_equal Harvest::Resources::Expense, @harvest.expenses
    end
    
    should "return the ExpenseCategory class" do
      assert_equal Harvest::Resources::ExpenseCategory, @harvest.expense_categories
    end
    
    should "return the Person class" do
      assert_equal Harvest::Resources::Project, @harvest.projects
    end
    
    should "return the Project class" do
      assert_equal Harvest::Resources::Project, @harvest.projects
    end
    
    should "return the Task class" do
      assert_equal Harvest::Resources::Task, @harvest.tasks
    end
    
  end
  
end