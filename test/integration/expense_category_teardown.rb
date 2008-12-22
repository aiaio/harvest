class ExpenseCategoryTeardown < Test::Unit::TestCase
  
  def test_should_destroy_the_expense_category
    expense_category = $harvest.expense_categories.find(:all).detect {|c| c.name == "GemEntertainment"}
    expense_category.destroy
    assert_raise ActiveResource::ResourceNotFound do 
      $harvest.expense_categories.find($test_expense_category)
    end
  end
  
end
  