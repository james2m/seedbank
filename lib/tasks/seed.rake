namespace :db do

  Rake::Task.extend(Seedbank::Task)
  Rake::Application.send(:include, Seedbank::TaskManager)
  include Seedbank::DSL

  base_dependencies   = ['db:seed:original']
  override_dependency = []
  common_dependencies = []

  # Create seed tasks for all the seeds in seeds_path and add them to the dependency
  # list along with the original db/seeds.rb.
  Dir.glob(File.join(seeds_root, '*.seeds.rb')).each do |seed_file|
    common_dependencies << define_seed_task(seed_file)
  end

  desc "Load the seed data from db/seeds.rb and db/seeds/*.seeds.rb."
  task ['seed', 'common'] => base_dependencies + common_dependencies

  # Glob through the directories under seeds_path assuming they are all environments
  # and create a task for each and add it to the dependency list. Then create a task
  # for the environment
  Dir[seeds_root + '/*/'].each do |e|
    environment = File.basename(e)

    environment_dependencies = []
    Dir.glob(File.join(seeds_root, environment, '*.seeds.rb')).sort.each do |seed_file|
      environment_dependencies << define_seed_task(seed_file)
    end

    desc <<-EOT
      Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/#{environment}/*.seeds.rb.
    EOT
    task ['seed', environment] => ['db:seed:common'] + environment_dependencies

    override_dependency << "db:seed:#{environment}" if Rails.env == environment
  end

  # Change db:seed task to run all the base seeds tasks defined above.
  desc <<-EOT
    Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/ENVIRONMENT/*.seeds.rb.
    ENVIRONMENT is the current environment in Rails.env.
  EOT
  override_task :seed => ['db:seed:common'] + override_dependency

end
