# lib/seedbank/errors.rb
# frozen_string_literal: true

module Seedbank
  class Error < StandardError; end

  class ConfigurationError < Error; end

  class DependencyError < Error
    def initialize(seed_task:, seed_file:, dependency:, problem:)
      location = seed_file ? " in #{seed_file}" : ''
      super("Seed #{seed_task}#{location} has invalid dependency #{dependency.inspect}: #{problem}")
    end
  end

  class DependencyCycleError < Error
    attr_reader :cycle

    def initialize(cycle:)
      @cycle = cycle
      super("Circular seed dependency detected: #{cycle.join(' -> ')}")
    end
  end

  class EvaluationError < Error
    attr_reader :original_error, :seed_file, :seed_task

    def initialize(seed_task:, seed_file:, original_error:)
      @original_error = original_error
      @seed_file = seed_file
      @seed_task = seed_task

      super("Failed to evaluate seed #{seed_task} from #{seed_file}: #{original_error.class}: #{original_error.message}")
    end
  end
end
