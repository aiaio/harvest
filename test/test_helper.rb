require "rubygems"
require "active_resource"
require "active_resource_throttle"
require "test/unit"
require "shoulda"
require "mocha"

# The integration test will not run by default.
# To run it, type:
#   rake test:integration
#
# If running the integration test, login credentials
# must be specified here. The integration test verifies
# that various resources in a Harvest account can be created, 
# deleted, updated, destroyed, etc.
#
# It's best to run this test on a trial account, where no 
# sensitive data can be manipulated.
#
# Leave these values nil if not running the integration test.
$integration_credentials = {:email      => nil,
                            :password   => nil,
                            :sub_domain => nil}

require File.join(File.dirname(__FILE__), "..", "lib", "harvest.rb")

# Disengage throttling if in unit test mode (Integration test needs throttling).
if ($test_mode ||= :unit) == :unit
  require "active_resource/http_mock"
  Harvest::HarvestResource.throttle(:interval => 0, :requests => 0)
  Harvest::HarvestResource.site = "http://example.com/"
end

# Load all available resources.
ResourcesPath = File.join(File.dirname(__FILE__), "..", "lib", "harvest", "resources")
Harvest.load_all_ruby_files_from_path(ResourcesPath)

# Custom assert_raise to test exception message in addition to the exception itself.
class Test::Unit::TestCase
  def assert_raise_plus(exception_class, exception_message, message=nil, &block)
    begin
      yield
    rescue => e
      error_message = build_message(message, '<?>, <?> expected but was <?>, <?>', exception_class, exception_message, e.class, e.message)
      assert_block(error_message) { e.class == exception_class && e.message == exception_message }
    else
      error_message = build_message(nil, '<?>, <?> expected but raised nothing.', exception_class, exception_message)
      assert_block(error_message) { false }
    end
  end
end