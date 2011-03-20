require 'seedbank/dsl'
require 'seedbank/task'
require 'seedbank/task_manager'

if defined?(Rake)
  Rake::Task.extend(Seedbank::Task)
  Rake::Application.send(:include, Seedbank::TaskManager)
end

module Seedbank
  
  @@seeds_root = 'db/seeds'
  
  def self.seeds_root
    @@seeds_root
  end
  
  def self.load_tasks
    Dir[File.expand_path("tasks/*.rake", File.dirname(__FILE__))].each { |ext| load ext } 
  end
  
  require 'seedbank/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
  
end