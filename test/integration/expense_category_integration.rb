class ExpenseCategoryIntegration < Test::Unit::TestCase

  def test_should_create_and_update_a_new_expense_category 
    # create
    expense_category = $harvest.expense_categories.new
    expense_category.name    = "GemEntertainmentBeforeUpdate"
    expense_category.save
    $test_expense_category = $harvest.expense_categories.find(:all).detect {|c| c.name == "GemEntertainmentBeforeUpdate"}
    
    #update
    expense_category.name = "GemEntertainment"
    expense_category.save
    assert_equal "GemEntertainment", $harvest.expense_categories.find(:all).detect {|c| c.name == "GemEntertainment"}.name
  end
  
end