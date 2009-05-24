module Harvest
  VERSION   = "0.8"
  ApiDomain = "harvestapp.com"
  
  # Class method to load all ruby files from a given path.
  def self.load_all_ruby_files_from_path(path)
    Dir.foreach(path) do |file|
      require File.join(path, file) if file =~ /\.rb$/
    end
  end
  
end

# Gems
require "rubygems"
require "activeresource"
require "active_resource_throttle"

# Plugins
PluginPath = File.join(File.dirname(__FILE__), "harvest", "plugins")
Harvest.load_all_ruby_files_from_path(PluginPath)

# Base
require File.join(File.dirname(__FILE__), "harvest", "base")
require File.join(File.dirname(__FILE__), "harvest", "harvest_resource")

# Shortcut for Harvest::Base.new
#
# Example:
# Harvest(:email      => "jack@exampe.com", 
#         :password   => "secret", 
#         :sub_domain => "frenchie",
#         :headers    => {"User-Agent => "Harvest Rubygem"})
def Harvest(options={})
  Harvest::Base.new(options)
end
