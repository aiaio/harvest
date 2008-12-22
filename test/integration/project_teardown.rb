class ProjectTeardown < Test::Unit::TestCase
  
  def test_should_destroy_the_project
    project = $harvest.projects.find($test_project.id)
    project.destroy
    assert_raise ActiveResource::ResourceNotFound do 
      $harvest.projects.find($test_project)
    end
  end
  
end
  