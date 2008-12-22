class ProjectIntegration < Test::Unit::TestCase
  
  def test_should_create_and_update_a_new_project
    # create
    project = $harvest.projects.new
    project.name    = "HarvestGem Project"
    project.active  = false
    project.bill_by = "None"
    project.client_id = $test_client.id
    project.save
    
    # update
    $test_project = $harvest.projects.find(:all).detect {|c| c.name == "HarvestGem Project"}
    project.active = true
    project.save
    assert $harvest.projects.find($test_project.id).active?
  end

end