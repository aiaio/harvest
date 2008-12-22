class TaskTeardown < Test::Unit::TestCase
  
  def test_should_destroy_the_task
    task = $harvest.tasks.find($test_task.id)
    task.destroy
    assert_raise ActiveResource::ResourceNotFound do 
      $harvest.tasks.find($test_task)
    end
  end
  
end
  