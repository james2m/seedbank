namespace :db do

  include Seedbank::DSL

  base_dependencies   = ['db:seed:original']
  override_dependency = ['db:seed:common']

  namespace :seed do
    # Create seed tasks for all the seeds in seeds_path and add them to the dependency
    # list along with the original db/seeds.rb.
    common_dependencies = glob_seed_files_matching('*_seeds.rb').sort.map { |seed_file| seed_task_from_file(seed_file) }

    desc "Load the seed data from db/seeds.rb and db/seeds/*_seeds.rb."
    task 'common' => base_dependencies + common_dependencies

    # Glob through the directories under seeds_path and create a task for each adding it to the dependency list.
    # Then create a task for the environment
    glob_seed_files_matching('/*/').each do |directory|
      environment = File.basename(directory)

      environment_dependencies = glob_seed_files_matching(environment, '*_seeds.rb').sort.map { |seed_file| seed_task_from_file(seed_file) }

      desc "Load the seed data from db/seeds.rb, db/seeds/*_seeds.rb and db/seeds/#{environment}/*_seeds.rb."
      task environment => ['db:seed:common'] + environment_dependencies

      override_dependency << "db:seed:#{environment}" if defined?(Rails) && Rails.env == environment
    end
  end

  # Override db:seed to run all the common and environments seeds plus the original db:seed.
  desc "Load the seed data from db/seeds.rb, db/seeds/*_seeds.rb and db/seeds/ENVIRONMENT/*_seeds.rb. ENVIRONMENT is the current environment in Rails.env."
  override_seed_task :seed => override_dependency

end
