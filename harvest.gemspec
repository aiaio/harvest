# -*- encoding: utf-8 -*-
 
 Gem::Specification.new do |s|
  s.name        = "harvest"
  s.version     = "0.8.2"
  s.authors     = ["Kyle Banker", "Alexander Interactive, Inc."]
  s.date        = "2008-12-17"
  s.summary     = "A wrapper for the Harvest Api.  See http://getharvest.com/api for details."
  s.homepage    = "http://github.com/aiaio/harvest"
  s.email       = "knb@alexanderinteractive.com"
  s.files       = ["HISTORY", "LICENSE", "Rakefile", "README.rdoc", "lib/harvest/plugins/active_resource_inheritable_headers.rb", "lib/harvest/plugins/toggleable.rb", "lib/harvest/resources/client.rb", "lib/harvest/resources/entry.rb", "lib/harvest/resources/expense.rb", "lib/harvest/resources/expense_category.rb", "lib/harvest/resources/person.rb", "lib/harvest/resources/project.rb", "lib/harvest/resources/task.rb", "lib/harvest/resources/task_assignment.rb", "lib/harvest/resources/user_assignment.rb", "lib/harvest/base.rb", "lib/harvest/harvest_resource.rb", "lib/harvest.rb"]
  s.require_paths = ["lib"]
  s.test_files = ["test/test_helper.rb", "test/unit/base_test.rb", "test/unit/resources/client_test.rb", "test/unit/resources/expense_test.rb", "test/unit/resources/expense_category_test.rb", "test/unit/resources/person_test.rb", "test/unit/resources/project_test.rb", "test/unit/resources/task_test.rb",  "test/unit/resources/task_assignment_test.rb", "test/unit/resources/user_assignment_test.rb", "test/integration/client_integration.rb", "test/integration/task_integration.rb", "test/integration/expense_category_integration.rb", "test/integration/project_integration.rb", "test/integration/harvest_integration_test.rb", "test/integration/client_teardown.rb", "test/integration/expense_category_teardown.rb", "test/integration/project_teardown.rb", "test/integration/task_teardown.rb"]
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.add_dependency("activeresource", [">= 2.1"])
  s.add_dependency("active_resource_throttle", [">= 1.0"])
end
