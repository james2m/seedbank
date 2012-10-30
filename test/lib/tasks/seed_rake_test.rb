require 'test_helper'

describe 'Seedbank rake.task' do

  describe "seeds with dependency" do

    subject { Rake.application.tasks_in_scope %w[db seed] }

    it "creates all the seed tasks" do
      seeds = %w(db:seed:circular1 db:seed:circular2 db:seed:common db:seed:dependency db:seed:dependency2
        db:seed:dependent db:seed:dependent_on_nested db:seed:dependent_on_several db:seed:development
        db:seed:development:users db:seed:no_block db:seed:original)

      subject.map(&:to_s).must_equal seeds
    end
  end

  describe "common seeds in the root directory" do

    Dir[File.expand_path('../../../dummy/db/seeds/*_seeds.rb', __FILE__)].each do |seed_file|
      seed = File.basename(seed_file, '_seeds.rb')

      describe seed do

        subject { Rake.application.lookup(seed, %w[db seed]) }

        it "is dependent on db:abort_if_pending_migrations" do
          subject.prerequisites.must_equal %w[db:abort_if_pending_migrations]
        end
      end
    end
  end

  describe "db:seed:common" do

    subject { Rake::Task['db:seed:common'] }

    it "is dependent on the common seeds and db:seed:original" do
      prerequisite_seeds = Dir[File.expand_path('../../../dummy/db/seeds/*_seeds.rb', __FILE__)].map do |seed_file|
        ['db', 'seed', File.basename(seed_file, '_seeds.rb')].join(':')
      end.unshift('db:seed:original')

      subject.prerequisites.must_equal prerequisite_seeds
    end
  end

  describe "db:seed:original" do

    subject { Rake::Task['db:seed:original'] }

    it "has no dependencies" do
      subject.prerequisites.must_be_empty
    end

    describe "when seeds are reloaded" do

      before do
        Dummy::Application.load_tasks
      end

      it "still has no dependencies" do
        subject.prerequisites.must_be_empty
      end
    end
  end

  describe "environment seeds" do

    Dir[File.expand_path('../../../dummy/db/seeds', __FILE__) + '/*/'].each do |environment_directory|
      environment = File.basename(environment_directory)

      describe "seeds in the #{environment} environment" do

        Dir[File.expand_path("../../../dummy/db/seeds/#{environment}/*_seeds.rb", __FILE__)].each do |seed_file|
          seed = File.basename(seed_file, '_seeds.rb')

          describe seed do

            subject { Rake.application.lookup(seed, ['db', 'seed', environment]) }

            it "is dependent on db:abort_if_pending_migrations" do
              subject.prerequisites.must_equal %w[db:abort_if_pending_migrations]
            end
          end
        end
      end

      describe "db:seed:#{environment}" do

        subject { Rake.application.lookup(environment, %w[db seed]) }

        it "is dependent on the seeds in the environment directory" do
          prerequisite_seeds = Dir[File.expand_path("../../../dummy/db/seeds/#{environment}/*_seeds.rb", __FILE__)].map do |seed_file|
            ['db', 'seed', environment, File.basename(seed_file, '_seeds.rb')].join(':')
          end.unshift('db:seed:common')

          subject.prerequisites.must_equal prerequisite_seeds
        end
      end
    end
  end

  describe "db:seed task" do

    subject { Rake::Task['db:seed'] }

    describe "when no environment seeds are defined" do

      it "is dependent on db:seed:common" do
        subject.prerequisites.must_equal %w[db:seed:common]
      end
    end

    describe "when environment seeds are defined" do

      it "is dependent on db:seed:common" do
        flexmock(Rails).should_receive(:env).and_return('development').once

        Rake.application.clear
        Dummy::Application.load_tasks

        subject.prerequisites.must_equal %w[db:seed:common db:seed:development]
      end
    end
  end
end
