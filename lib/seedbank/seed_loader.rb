# lib/seedbank/seed_loader.rb
# frozen_string_literal: true

module Seedbank
  # Adapts Seedbank's generated tasks to Rails' native seed-loader contract.
  class SeedLoader
    def initialize(environment: -> { Rails.env.to_s })
      @environment = environment
    end

    def load_seed
      Rake::Task['db:seed:common'].invoke

      environment_task = "db:seed:#{@environment.call}"
      Rake::Task[environment_task].invoke if Rake::Task.task_defined?(environment_task)
    end
  end
end
