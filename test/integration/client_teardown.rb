class ClientTeardown < Test::Unit::TestCase

  def test_should_destroy_the_client
    client = $harvest.clients.find($test_client.id)
    client.destroy
    assert_raise ActiveResource::ResourceNotFound do 
      $harvest.clients.find($test_client)
    end
  end
        
end