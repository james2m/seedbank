# frozen_string_literal: true
module Seedbank
  class Railtie < Rails::Railtie
    rake_tasks do
      ActiveRecord::Tasks::DatabaseTasks.seed_loader = Seedbank::SeedLoader.new
      Seedbank.load_tasks
    end
  end
end
