$:.unshift File.dirname(__FILE__)
$test_mode = :integration

require File.join(File.dirname(__FILE__), "..", "test_helper")
require "test/unit/testsuite"
require "test/unit/ui/console/testrunner"

require "client_integration"
require "client_teardown"
require "expense_category_integration"
require "expense_category_teardown"
require "project_integration"
require "project_teardown"
require "task_integration"
require "task_teardown"


# Make sure that credentials have been specified:
if [:email, :password, :sub_domain].any? { |k| $integration_credentials[k].nil? }
  raise ArgumentError, "Integration test cannot be run without login credentials; Please specify in test/test_helper.rb"
end

# Initialize a harvest object with credentials.
$harvest = Harvest($integration_credentials)

# Global variables to hold resources
# for later reference.
$test_client  = nil
$test_project = nil
$test_person  = nil
   
class HarvestIntegration
  def self.suite
    suite = Test::Unit::TestSuite.new
    suite << ExpenseCategoryIntegration.suite
    suite << TaskIntegration.suite
    suite << ClientIntegration.suite
    suite << ProjectIntegration.suite
    suite << ProjectTeardown.suite
    suite << ClientTeardown.suite
    suite << TaskTeardown.suite
    suite << ExpenseCategoryTeardown.suite
    return suite
  end
end

Test::Unit::UI::Console::TestRunner.run(HarvestIntegration)