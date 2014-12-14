require 'rubygems'
require 'minitest/autorun'

# Configure Rails Environment
environment  = ENV["RAILS_ENV"] = 'test'
rails_root   = File.expand_path('../dummy', __FILE__)

require File.expand_path('config/environment.rb', rails_root)

Rails.backtrace_cleaner.remove_silencers!

Seedbank.seeds_root = File.expand_path('dummy/db/seeds', __FILE__)

class Seedbank::Spec < MiniTest::Spec

  def setup
    Rake.application = Rake::Application.new
    Dummy::Application.load_tasks
    Object.const_set :FakeModel, MiniTest::Mock.new
    TOPLEVEL_BINDING.eval('self').send(:instance_variable_set, :@_seedbank_runner, Seedbank::Runner.new)
    super
  end

end

MiniTest::Spec.register_spec_type(/^Seedbank/i, Seedbank::Spec)
MiniTest.autorun
