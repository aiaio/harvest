require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class ExpenseAssignmentTest < Test::Unit::TestCase

  context "ExpenseAssignment class" do 
    
    should "adjust the site setting when the person_id is set" do 
      expense_class = Harvest::Resources::Expense.clone
      expense_class.person_id = 5
      assert_equal "http://example.com/people/5", expense_class.site.to_s
    end
    
  end
end