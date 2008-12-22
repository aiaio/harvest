class ClientIntegration < Test::Unit::TestCase

  def test_should_create_and_update_a_new_client 
    # create
    client = $harvest.clients.new
    client.name    = "HarvestGem, INC"
    client.details = "New York, NY"
    client.save
    $test_client = $harvest.clients.find(:all).detect {|c| c.name == "HarvestGem, INC"}
    
    #update
    client.details = "San Francisco, CA"
    client.save
    assert_equal "San Francisco, CA", $harvest.clients.find($test_client.id).details
  end
  
end