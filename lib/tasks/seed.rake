namespace :db do
  
  include Seedbank::DSL
  
  base_dependencies = ['db:seed:original']
  override_dependency = []
    
  common_dependencies = []
  # Create seed tasks for all the seeds in seeds_path and add them to the dependency 
  # list along with the original db/seeds.rb.
  Dir.glob(File.join(seeds_root, '*.seeds.rb')).each do |seed_file|
    common_dependencies << define_seed_task(seed_file)
  end
  
  desc "Loads db/seeds.rb, db/seeds/*.seeds.rb."
  task ['seed', 'common'] => base_dependencies + common_dependencies
  
  # Glob through the directories under seeds_path assuming they are all environments
  # and create a task for each and add it to the dependency list. Then create a task
  # for the environment
  Dir[seeds_root + '/*/'].each do |e|
    environment = File.basename(e)
     
    environment_dependencies = []
    Dir.glob(File.join(seeds_root, environment, '*.seeds.rb')).each do |seed_file|
      environment_dependencies << define_seed_task(seed_file)
    end
  
    desc "Loads db/seeds.rb, db/seeds/*.seeds.rb and any seeds in db/seeds/#{environment}/*.seeds.rb."
    task ['seed', environment] => ['db:seed:common'] + environment_dependencies
    
    override_dependency << "db:seed:#{environment}" if Rails.env == environment
  end

  # Change db:seed task to run all the base seeds tasks defined above.
  desc <<-EOT
    Loads the original seeds in db/seeds.rb followed by db/seeds/*.seeds.rb then
    db/seeds/environment/*.seeds.rb
  EOT
  override_task :seed => ['db:seed:common'] + override_dependency
  
end
