require 'seedbank/dsl'
require 'seedbank/runner'

module Seedbank

  class << self

    attr_writer :seeds_root

    def seeds_root
      @seeds_root ||= 'db/seeds'
    end

  end

  def self.load_tasks
    Dir[File.expand_path("tasks/*.rake", File.dirname(__FILE__))].each { |ext| load ext }
  end

  require 'seedbank/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3

end