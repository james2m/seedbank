namespace :db do

  include Seedbank::DSL

  base_dependencies   = ['db:seed:original']
  override_dependency = ['db:seed:common']

  namespace :seed do
    # Create seed tasks for all the seeds in seeds_path and add them to the dependency
    # list along with the original db/seeds.rb.
    common_dependencies = glob_seed_files_matching('*.seeds.rb').sort.map { |seed_file| seed_task_from_file(seed_file) }

    desc "Load the seed data from db/seeds.rb and db/seeds/*.seeds.rb."
    task 'common' => base_dependencies + common_dependencies

    # Glob through the directories under seeds_path and create a task for each adding it to the dependency list.
    # Then create a task for the environment
    glob_seed_files_matching('/*/').each do |directory|
      environment = File.basename(directory)

      environment_dependencies = glob_seed_files_matching(environment, '*.seeds.rb').sort.map { |seed_file| seed_task_from_file(seed_file) }

      desc "Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/#{environment}/*.seeds.rb."
      task environment => ['db:seed:common'] + environment_dependencies

      override_dependency << "db:seed:#{environment}" if defined?(Rails) && Rails.env == environment
    end

    if Rails.version > '4'
      original_seeds_file = Rails.application.paths["db/seeds.rb"].existent.first
    elsif Rails.version > '3'
      original_seeds_file = Rails.application.paths["db/seeds"].existent.first
    else
      original_seeds_file = Rails.root.join("db","seeds").children.first.to_s
    end
    define_seed_task original_seeds_file, :original if original_seeds_file
  end

  # Override db:seed to run all the common and environments seeds plus the original db:seed.
  desc 'Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/ENVIRONMENT/*.seeds.rb. ENVIRONMENT is the current environment in Rails.env.'
  override_seed_task :seed => override_dependency
end
