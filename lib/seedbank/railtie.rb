require 'seedbank'
require 'rails'

module Seedbank
  class Railtie < Rails::Railtie

    rake_tasks do
      Seedbank.seeds_root = File.expand_path('db/seeds', Rails.root)
      Seedbank.load_tasks
    end

  end
end