# test/lib/seedbank/standalone_test.rb
# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'test_helper'

describe 'Seedbank standalone integration' do
  it 'loads common and environment seed tasks without Rails' do
    Dir.mktmpdir('seedbank-standalone') do |root|
      FileUtils.mkdir_p(File.join(root, 'db/seeds/development'))
      File.write(File.join(root, 'db/seeds/accounts.seeds.rb'), "raise 'seed body executed during task loading'\n")
      File.write(File.join(root, 'db/seeds/development/users.seeds.rb'), "raise 'seed body executed during task loading'\n")

      script = <<~RUBY
        require 'pathname'
        require 'rake'
        require 'seedbank'

        abort 'Rails loaded' if defined?(Rails)

        Seedbank.application_root = Pathname.new(ARGV.fetch(0))
        Seedbank.load_tasks

        puts Rake::Task.task_defined?('db:seed:accounts')
        puts Rake::Task.task_defined?('db:seed:development:users')
      RUBY
      library = File.expand_path('../../../lib', __dir__)

      output, error, status = Bundler.with_unbundled_env do
        Open3.capture3(RbConfig.ruby, "-I#{library}", '-e', script, root)
      end

      assert status.success?, error
      _(output.lines.map(&:strip)).must_equal %w[true true]
    end
  end
end
