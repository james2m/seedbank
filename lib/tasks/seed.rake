# frozen_string_literal: true
namespace :db do
  using Seedbank::DSL
  override_dependency = ['db:seed:common']

  namespace :seed do
    # Create seed tasks for all the seeds in seeds_path and add them to the dependency
    # list along with the original db/seeds.rb.
    common_dependencies = seed_tasks_matching(Seedbank.matcher)

    # Only add the original seeds if db/seeds.rb exists.
    if original_seeds_file
      define_seed_task original_seeds_file, :original
      common_dependencies.unshift('db:seed:original')
    end

    desc "Load the seed data from db/seeds.rb and db/seeds/#{Seedbank.matcher}."
    task 'common' => common_dependencies

    # Glob through the directories under seeds_path and create a task for each adding it to the dependency list.
    # Then create a task for the environment
    glob_seed_files_matching('/*/').each do |directory|
      environment = File.basename(directory)

      environment_dependencies = seed_tasks_matching(environment, Seedbank.matcher)

      desc "Load the seed data from db/seeds.rb, db/seeds/#{Seedbank.matcher} and db/seeds/#{environment}/#{Seedbank.matcher}."
      task environment => ['db:seed:common'] + environment_dependencies

      override_dependency << "db:seed:#{environment}" if defined?(Rails) && Rails.env == environment
    end
  end

  # Override db:seed to run all the common and environments seeds plus the original db:seed.
  desc %(Load the seed data from db/seeds.rb, db/seeds/#{Seedbank.matcher} and db/seeds/ENVIRONMENT/#{Seedbank.matcher}.
  ENVIRONMENT is the current Rails.env.)
  override_seed_task seed: override_dependency
end
