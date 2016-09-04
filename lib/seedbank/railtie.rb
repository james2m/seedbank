module Seedbank
  class Railtie < Rails::Railtie
    rake_tasks do
      Seedbank.load_tasks
    end
  end
end
