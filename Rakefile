# -*- ruby -*-

require 'rubygems'
require 'rake'
require 'rake/testtask'
require './lib/harvest.rb'

desc 'Default: run all tests.'
task :default => :test_all

namespace :test do

  Rake::TestTask.new(:resources) do |t|
    t.libs << 'lib'
    t.pattern = 'test/unit/resources/*_test.rb'
    t.verbose = false
  end
  
  Rake::TestTask.new(:base) do |t|
    t.libs << 'lib'
    t.pattern = 'test/unit/*_test.rb'
    t.verbose = false
  end
  
  Rake::TestTask.new(:integration) do |t|
    t.libs << 'lib'
    t.pattern = 'test/integration/*_test.rb'
    t.verbose = false
  end

end

desc "Test everything."
task :test_all do
  errors = %w(test:resources test:base).collect do |task|
    begin
      Rake::Task[task].invoke
      nil
    rescue => e
      task
    end
  end.compact
  abort "Errors running #{errors.to_sentence}!" if errors.any?
end