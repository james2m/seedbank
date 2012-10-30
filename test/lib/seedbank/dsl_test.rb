require 'test_helper'

describe Seedbank::DSL do

  describe "scope_from_seed_file" do

    it "is added to the namesapce" do
      ns = Rake.application.in_namespace(:seedy) { self }

      ns.must_respond_to :scope_from_seed_file
    end

    describe "in an environment directory" do

      let(:seed_file) { File.expand_path('development/users_seeds.rb', Seedbank.seeds_root) }
      let(:seed_namespace) { %w(development) }

      subject { Seedbank::DSL.scope_from_seed_file seed_file }

      it "returns the enviroment scope" do
        subject.must_equal seed_namespace
      end
    end

    describe "in a nested directory" do

      let(:seed_file) { File.expand_path('development/shared/accounts_seeds.rb', Seedbank.seeds_root) }
      let(:seed_namespace) { %w(development shared) }

      subject { Seedbank::DSL.scope_from_seed_file seed_file }

      it "returns the nested scope" do
        subject.must_equal seed_namespace
      end
    end

    describe "in seeds root" do

      let(:seed_file) { File.expand_path('no_block_seeds.rb', Seedbank.seeds_root) }

      subject { Seedbank::DSL.scope_from_seed_file seed_file }

      it "returns an array" do
        subject.must_be_instance_of Array
      end

      it "must be empty" do
        subject.must_be_empty
      end
    end
  end

  describe "seeds_root" do

    let(:seeds_root) { '/my/seeds/directory' }

    subject { Seedbank::DSL.seeds_root }

    it "returns a Pathname" do
      flexmock(Seedbank).should_receive(:seeds_root).and_return(seeds_root).by_default

      subject.must_equal Pathname.new(seeds_root)
    end

  end

  describe "glob_seed_files_matching" do

    describe "with no namespace" do

      let(:pattern) { '*_seeds.rb' }

      it "returns all the files matching the pattern in seeds_root" do
        expected_files = Dir.glob(File.join(Seedbank.seeds_root, pattern))

        Seedbank::DSL.glob_seed_files_matching(pattern).must_equal expected_files
      end

    end

    describe "with a namespace" do

      let(:pattern) { '*_seeds.rb' }
      let(:namespace) { 'development' }

      it "returns all the files matching the pattern in seeds_root" do
        expected_files = Dir.glob(File.join(Seedbank.seeds_root, namespace, pattern))

        Seedbank::DSL.glob_seed_files_matching(namespace, pattern).must_equal expected_files
      end

    end

  end

  describe "define_seed_task" do

    let(:name) { 'scoped:my_seed' }
    let(:dependencies) { ['environment'] }
    let(:seed_file) { File.expand_path('development/users_seeds.rb', Seedbank.seeds_root) }

    it "returns a fully qualified task name" do
      returned_name = Seedbank::DSL.define_seed_task(seed_file, name => dependencies)

      returned_name.must_equal name
    end

    it "creates a Rake Task" do
      Seedbank::DSL.define_seed_task(seed_file, name => dependencies)

      Rake::Task[name].wont_be_nil
    end

    it "sets Rake Task dependencies" do
      Seedbank::DSL.define_seed_task(seed_file, name => dependencies)

      Rake::Task[name].prerequisite_tasks.must_equal dependencies.map { |dependency| Rake::Task[dependency] }
    end

    it "sets Rake Task description" do
      Seedbank::DSL.define_seed_task(seed_file, name => dependencies)

      Rake::Task[name].comment.must_equal "Load the seed data from #{seed_file}"
    end

    it "sets Rake Task action to the seed_file contents" do
      Seedbank::DSL.define_seed_task(seed_file, name => dependencies)

      flexmock(FakeModel).should_receive(:seed).with('development:users').once.ordered

      Rake::Task[name].invoke
    end
  end

  describe "override_seed_task" do

    let(:arguments) { 'my_task' }

    it "calls Rake::TaskManager#override_task" do
      block = proc {}
      flexmock(Rake.application).should_receive(:override_task).with(arguments, block).once

      Seedbank::DSL.override_seed_task(arguments, &block)
    end
  end
end
