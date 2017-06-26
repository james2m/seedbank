# frozen_string_literal: true
require 'test_helper'
using Seedbank::DSL

describe 'Seedbank rake.task' do
  def self.dummy_seeds_root
    Pathname.new('../../../dummy/db/seeds').expand_path(__FILE__)
  end

  def self.glob_dummy_seeds
    Pathname.glob(dummy_seeds_root.join(Seedbank.matcher), Seedbank.nesting)
  end

  it 'does not pollute the global namespace' do
    Object.new.wont_respond_to :seeds_root
  end

  describe 'seeds with dependency' do
    subject { Rake.application.tasks_in_scope(defined?(Rake::Scope) ? Rake::Scope.new('db:seed') : %w[db seed]) }

    it 'creates all the seed tasks' do
      seeds = %w[db:seed:circular1 db:seed:circular2 db:seed:common db:seed:dependency db:seed:dependency2
                 db:seed:dependent db:seed:dependent_on_nested db:seed:dependent_on_several db:seed:development
                 db:seed:development:users db:seed:no_block db:seed:original db:seed:reference_memos db:seed:with_block_memo db:seed:with_inline_memo]

      subject.map(&:to_s).must_equal seeds
    end
  end

  describe 'common seeds in the root directory' do
    glob_dummy_seeds.each do |seed_file|
      seed = File.basename(seed_file, '.seeds.rb')

      describe seed do
        subject { Rake.application.lookup(['db', 'seed', seed].join(':')) }

        it 'is dependent on db:abort_if_pending_migrations' do
          subject.prerequisites.must_equal %w[db:abort_if_pending_migrations]
        end
      end
    end
  end

  describe 'db:seed:common' do
    subject { Rake::Task['db:seed:common'] }

    describe 'when db/seeds.rb exists' do
      it 'is dependent on the common seeds and db:seed:original' do
        prerequisite_seeds = self.class.glob_dummy_seeds.sort.map do |seed_file|
          ['db', 'seed', File.basename(seed_file, '.seeds.rb')].join(':')
        end.unshift('db:seed:original')

        subject.prerequisites.must_equal prerequisite_seeds
      end
    end

    describe 'when db/seeds.rb does not exist' do
      def setup
        main = TOPLEVEL_BINDING.eval('class << self; self; end')
        orig = original_seeds_file
        main.send(:undef_method, :original_seeds_file) if main.respond_to?(:original_seeds_file, true)
        main.send(:define_method, :original_seeds_file) { nil }
        super
        main.send(:undef_method, :original_seeds_file)
        main.send(:define_method, :original_seeds_file) { orig }
      end

      it 'is dependent on only the common seeds' do
        prerequisite_seeds = self.class.glob_dummy_seeds.sort.map do |seed_file|
          ['db', 'seed', File.basename(seed_file, '.seeds.rb')].join(':')
        end

        subject.prerequisites.must_equal prerequisite_seeds
      end
    end
  end

  describe 'db:seed:original' do
    subject { Rake::Task['db:seed:original'] }

    it 'is only dependent on db:abort_if_pending_migrations' do
      subject.prerequisites.must_equal %w[db:abort_if_pending_migrations]
    end

    it 'runs within Seedbank::Runner' do
      FakeModel.expect :seed, true, ['db/seeds.rb']

      subject.invoke

      FakeModel.verify
    end

    describe 'when seeds are reloaded' do
      before do
        silence_warnings { Dummy::Application.load_tasks }
      end

      it 'is still only dependent on db:abort_if_pending_migrations' do
        subject.prerequisites.must_equal %w[db:abort_if_pending_migrations]
      end

      it 'still runs within Seedbank::Runner' do
        skip 'TODO: Appears that it gets invoked twice after reloading.'
        FakeModel.expect :seed, true, ['db/seeds.rb']

        subject.invoke

        FakeModel.verify
      end
    end
  end

  describe 'environment seeds ' do
    dummy_seeds_root.each_child.select(&:directory?).each do |environment_directory|
      environment = File.basename(environment_directory)

      describe "in the #{environment} environment " do
        Pathname.glob(environment_directory.join(Seedbank.matcher), Seedbank.nesting).each do |seed_file|
          seed = File.basename(seed_file, '.seeds.rb')

          describe seed do
            subject { Rake.application.lookup(['db', 'seed', environment, seed].join(':')) }

            it 'is dependent on db:abort_if_pending_migrations' do
              subject.prerequisites.must_equal %w[db:abort_if_pending_migrations] if subject
            end
          end
        end
      end

      describe "db:seed:#{environment}" do
        subject { Rake.application.lookup(['db', 'seed', environment].join(':')) }

        it 'is dependent on the seeds in the environment directory' do
          prerequisite_seeds = Pathname.glob(environment_directory.join(Seedbank.matcher), Seedbank.nesting).sort.map do |seed_file|
            ['db', 'seed', environment, File.basename(seed_file, '.seeds.rb')].join(':')
          end.unshift('db:seed:common')

          subject.prerequisites.must_equal prerequisite_seeds
        end
      end
    end
  end

  describe 'db:seed task' do
    subject { Rake::Task['db:seed'] }

    describe 'when no environment seeds are defined' do
      it 'is dependent on db:seed:common' do
        subject.prerequisites.must_equal %w[db:abort_if_pending_migrations db:seed:common]
      end
    end

    describe 'when environment seeds are defined' do
      it 'is dependent on db:seed:common' do
        Rails.stub(:env, 'development') do
          Rake.application.clear
          silence_warnings { Dummy::Application.load_tasks }

          subject.prerequisites.must_equal %w[db:abort_if_pending_migrations db:seed:common db:seed:development]
        end
      end
    end
  end
end
