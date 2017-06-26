# frozen_string_literal: true
require 'test_helper'

using Seedbank::DSL

describe Seedbank::DSL do
  # TODO: This is private so should really be tested indirectly.
  describe 'scope_from_seed_file' do
    subject { scope_from_seed_file(seed_file) }

    describe 'in an environment directory' do
      let(:seed_file) { File.expand_path('development/users.seeds.rb', Seedbank.seeds_root) }
      let(:seed_namespace) { %w[development] }

      it 'returns the enviroment scope' do
        subject.must_equal seed_namespace
      end
    end

    describe 'in a nested directory' do
      let(:seed_file) { File.expand_path('development/shared/accounts.seeds.rb', Seedbank.seeds_root) }
      let(:seed_namespace) { %w[development shared] }

      it 'returns the nested scope' do
        subject.must_equal seed_namespace
      end
    end

    describe 'in seeds root' do
      let(:seed_file) { File.expand_path('no_block.seeds.rb', Seedbank.seeds_root) }

      it 'returns an array' do
        subject.must_be_instance_of Array
      end

      it 'must be empty' do
        subject.must_be_empty
      end
    end
  end

  describe 'seeds_root' do
    let(:seeds_root) { '/my/seeds/directory' }

    subject { Seedbank::DSL.seeds_root }

    it 'returns a Pathname' do
      Seedbank.stub(:seeds_root, seeds_root) do
        subject.must_equal Pathname.new(seeds_root)
      end
    end
  end

  describe 'glob_seed_files_matching' do
    describe 'with no namespace' do
      let(:pattern) { '*.seeds.rb' }

      it 'returns all the files matching the pattern in seeds_root' do
        expected_files = Dir.glob(File.join(Seedbank.seeds_root, pattern))

        Seedbank::DSL.glob_seed_files_matching(pattern).must_equal expected_files
      end
    end

    describe 'with a namespace' do
      let(:pattern) { '*.seeds.rb' }
      let(:namespace) { 'development' }

      it 'returns all the files matching the pattern in seeds_root' do
        expected_files = Dir.glob(File.join(Seedbank.seeds_root, namespace, pattern))

        Seedbank::DSL.glob_seed_files_matching(namespace, pattern).must_equal expected_files
      end
    end
  end

  describe 'define_seed_task' do
    subject { Seedbank::DSL.define_seed_task(seed_file, task_name => dependencies) }

    let(:task_name) { 'scoped:my_seed' }
    let(:dependencies) { ['scoped:another_seed'] }
    let(:seed_file) { File.expand_path('development/users.seeds.rb', Seedbank.seeds_root) }

    def define_prerequisite_task
      Rake::Task.define_task('scoped:another_seed')
    end

    before do
      define_prerequisite_task
    end

    it 'returns a fully qualified task name' do
      subject.must_equal task_name
    end

    it 'creates a Rake Task' do
      subject
      Rake::Task[task_name].wont_be_nil
    end

    it 'sets Rake Task description' do
      subject
      relative_file = Pathname.new(seed_file).relative_path_from(Rails.root)

      Rake::Task[task_name].comment.must_equal "Load the seed data from #{relative_file}"
    end

    it 'sets Rake Task action to the seed_file contents' do
      subject
      FakeModel.expect :seed, true, ['development:users']
      Rake::Task[task_name].invoke
    end

    describe 'when db:abort_if_pending_migrations exists' do
      it 'sets Rake Task dependencies' do
        subject
        expected_dependencies = dependencies.map { |dependency| Rake::Task[dependency] }
        expected_dependencies << Rake::Task['db:abort_if_pending_migrations']

        Rake::Task[task_name].prerequisite_tasks.must_equal expected_dependencies
      end
    end

    describe 'when db:abort_if_pending_migrations does not exist' do
      it 'adds environment dependency' do
        Rake.application.clear
        define_prerequisite_task

        expected_dependencies = dependencies.map { |dependency| Rake::Task[dependency] }
        expected_dependencies << Rake::Task.define_task('environment')
        subject

        Rake::Task[task_name].prerequisite_tasks.must_equal expected_dependencies
      end
    end
  end

  describe 'override_seed_task' do
    describe 'when no task exists to override' do
      let(:task_name) { 'my_task' }
      let(:dependencies) { ['db:abort_if_pending_migrations'] }

      it 'creates a new task' do
        Seedbank::DSL.override_seed_task(task_name => dependencies)

        Rake::Task[task_name].wont_be_nil
      end

      it 'applies the dependencies' do
        expected_dependencies = dependencies.map { |dependency| Rake::Task[dependency] }
        Seedbank::DSL.override_seed_task(task_name => dependencies)

        Rake::Task[task_name].prerequisite_tasks.must_equal expected_dependencies
      end

      it 'applies the description' do
        description = 'Expected Description'
        Rake.application.last_description = description

        Seedbank::DSL.override_seed_task(task_name => dependencies)

        Rake::Task[task_name].full_comment.must_equal description
      end
    end
  end
end
