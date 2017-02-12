# frozen_string_literal: true
require 'rake'
require 'minitest/autorun'
require 'active_record/railtie'

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'dummy/config/application'

Rails.backtrace_cleaner.remove_silencers!

Seedbank.application_root = Pathname.new(File.expand_path('../dummy', __FILE__))

class Seedbank::Spec < MiniTest::Spec
  def setup
    silence_warnings do
      Rake.application = Rake::Application.new
      Dummy::Application.load_tasks
      Object.const_set :FakeModel, MiniTest::Mock.new
      TOPLEVEL_BINDING.eval('self').send(:instance_variable_set, :@_seedbank_runner, Seedbank::Runner.new)
    end

    super
  end
end

MiniTest::Spec.register_spec_type(/^Seedbank/i, Seedbank::Spec)
MiniTest.autorun
