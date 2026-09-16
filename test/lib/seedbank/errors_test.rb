# test/lib/seedbank/errors_test.rb
# frozen_string_literal: true

require 'fileutils'
require 'tempfile'
require 'tmpdir'
require 'test_helper'

describe 'Seedbank diagnostics' do
  def evaluate(source)
    Tempfile.create(['diagnostic', '.seeds.rb']) do |file|
      file.write(source)
      file.flush

      task = Rake::Task.define_task('db:seed:diagnostic')
      return Seedbank::Runner.new.evaluate(task, file.path)
    end
  end

  it 'identifies missing dependencies' do
    error = assert_raises(Seedbank::DependencyError) { evaluate('after :missing') }

    _(error.message).must_include 'db:seed:diagnostic'
    _(error.message).must_include 'db:seed:missing'
    _(error.message).must_include 'no matching seed task was discovered'
  end

  it 'identifies malformed dependencies' do
    error = assert_raises(Seedbank::DependencyError) { evaluate('after Object.new') }

    _(error.message).must_include 'expected a String or Symbol'
  end

  it 'rejects empty dependency names' do
    error = assert_raises(Seedbank::DependencyError) { evaluate("after ''") }

    _(error.message).must_include 'dependency names cannot be empty'
  end

  it 'preserves evaluation errors as the cause' do
    error = assert_raises(Seedbank::EvaluationError) { evaluate("raise 'broken seed'") }

    _(error.message).must_include 'db:seed:diagnostic'
    _(error.message).must_include 'broken seed'
    _(error.cause).must_be_instance_of RuntimeError
    _(error.original_error).must_be_same_as error.cause
  end

  it 'preserves syntax errors as the cause' do
    error = assert_raises(Seedbank::EvaluationError) { evaluate('def broken(') }

    _(error.cause).must_be_instance_of SyntaxError
  end

  it 'identifies seed names that conflict with environment directories' do
    Dir.mktmpdir('seedbank-ambiguous') do |root|
      seeds_root = File.join(root, 'db', 'seeds')
      FileUtils.mkdir_p(File.join(seeds_root, 'development'))
      File.write(File.join(seeds_root, 'development.seeds.rb'), '')
      File.write(File.join(seeds_root, 'development', 'users.seeds.rb'), '')
      previous_seeds_root = Seedbank.seeds_root
      Seedbank.seeds_root = seeds_root
      Rake.application = Rake::Application.new

      error = assert_raises(Seedbank::ConfigurationError) { Seedbank.load_tasks }

      _(error.message).must_include 'db:seed:development'
      _(error.message).must_include File.join(seeds_root, 'development')
    ensure
      Seedbank.seeds_root = previous_seeds_root
    end
  end
end
