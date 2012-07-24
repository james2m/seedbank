namespace :db do

  include Seedbank::DSL

  base_dependencies   = ['db:seed:original']
  override_dependency = []

  namespace :seed do
    # Create seed tasks for all the seeds in seeds_path and add them to the dependency
    # list along with the original db/seeds.rb.
    common_dependencies = glob_seed_files_matching('*.seeds.rb').map { |seed_file| seed_task_from_file(seed_file) }

    desc "Load the seed data from db/seeds.rb and db/seeds/*.seeds.rb."
    task 'common' => base_dependencies + common_dependencies

    # Glob through the directories under seeds_path assuming they are all environments
    # and create a task for each and add it to the dependency list. Then create a task
    # for the environment
    glob_seed_files_matching('/*/').each do |directory|
      environment = File.basename(directory)

      environment_dependencies = glob_seed_files_matching(environment, '*.seeds.rb').sort.map { |seed_file| seed_task_from_file(seed_file) }

      desc "Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/#{environment}/*.seeds.rb."
      task environment => ['db:seed:common'] + environment_dependencies

      override_dependency << "db:seed:#{environment}" if Rails.env == environment
    end
  end

  # Change db:seed task to run all the base seeds tasks defined above.
  desc <<-EOT
    Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/ENVIRONMENT/*.seeds.rb.
    ENVIRONMENT is the current environment in Rails.env.
  EOT
  override_seed_task :seed => ['db:seed:common'] + override_dependency

end
