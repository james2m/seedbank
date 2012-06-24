require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require 'active_record'

# Configure Rails Environment
environment  = ENV["RAILS_ENV"] = 'test'
rails_root   = File.expand_path('../dummy', __FILE__)
database_yml = File.expand_path('config/database.yml', rails_root)

ActiveRecord::Base.configurations = YAML.load_file(database_yml)

config = ActiveRecord::Base.configurations[environment]
db     = File.expand_path(config['database'], rails_root)

# Drop the test database and migrate up
FileUtils.rm(db) if File.exist?(db)
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => db)
ActiveRecord::Base.connection
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.up File.expand_path('db/migrate', rails_root)

# Load dummy rails app
require File.expand_path('config/environment.rb', rails_root)

Rails.backtrace_cleaner.remove_silencers!

