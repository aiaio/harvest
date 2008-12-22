class TaskIntegration < Test::Unit::TestCase
  
  def test_should_create_and_update_a_new_task
    # create
    task = $harvest.tasks.new
    task.billable_by_default  = false
    task.default_hourly_rate  = 100
    task.is_default           = false
    task.name                 = "GemIntegration"
    task.save
    
    # update
    $test_task = $harvest.tasks.find(:all).detect {|t| t.name == "GemIntegration"}
    task.name = "GemIntegrationUpdated"
    task.save
    assert_equal "GemIntegrationUpdated", $harvest.tasks.find($test_task.id).name
  end

end