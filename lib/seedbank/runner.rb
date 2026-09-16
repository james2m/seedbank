# lib/seedbank/runner.rb
# frozen_string_literal: true

module Seedbank
  class Runner
    def initialize
      @_memoized = {}
      @_seed_stack = []
    end

    # Run this seed after the specified dependencies have run
    # @param dependencies [Array] seeds to run before the block is executed
    #
    # If a block is specified the contents of the block are executed after all the
    # dependencies have been executed.
    #
    # If no block is specified just the dependencies are run. This makes it possible
    # to create shared dependencies. For example
    #
    # @example db/seeds/production/users.seeds.rb
    #   after 'shared:users'
    #
    # Would look for a db/seeds/shared/users.seeds.rb seed and execute it.
    def after(*dependencies, &block)
      depends_on = dependencies.map { |dependency| dependency_task_name(dependency) }
      missing_dependencies = depends_on.reject { |dependency| Rake::Task.task_defined?(dependency) }
      unless missing_dependencies.empty?
        raise DependencyError.new(
          seed_task: @_seed_task.name,
          seed_file: @_seed_file,
          dependency: missing_dependencies.first,
          problem: 'no matching seed task was discovered'
        )
      end

      depends_on.each do |dependency|
        cycle_start = @_seed_stack.index(dependency)
        next unless cycle_start

        raise DependencyCycleError.new(cycle: @_seed_stack[cycle_start..] + [dependency])
      end

      dependent_task_name = @_seed_task.name + ':body'

      if Rake::Task.task_defined?(dependent_task_name)
        dependent_task = Rake::Task[dependent_task_name]
      else
        dependent_task = Rake::Task.define_task(dependent_task_name => depends_on, &block)
      end

      dependent_task.invoke
    end

    def let(name, &block)
      name = String(name)

      raise ArgumentError, "#{name} is already defined" if respond_to?(name, true)

      define_singleton_method(name) do
        @_memoized.fetch(name) { |key| @_memoized[key] = instance_exec(&block) }
      end
    end

    def let!(name, &block)
      let(name, &block)
      public_send name
    end

    def evaluate(seed_task, seed_file)
      previous_seed_task = @_seed_task
      previous_seed_file = @_seed_file
      @_seed_task = seed_task
      @_seed_file = seed_file
      @_seed_stack << seed_task.name
      instance_eval(File.read(seed_file), seed_file)
    rescue Seedbank::Error
      raise
    rescue SyntaxError, StandardError => error
      raise EvaluationError.new(seed_task: seed_task.name, seed_file: seed_file, original_error: error), cause: error
    ensure
      @_seed_stack.pop
      @_seed_task = previous_seed_task
      @_seed_file = previous_seed_file
    end

    private

    def dependency_task_name(dependency)
      unless dependency.is_a?(String) || dependency.is_a?(Symbol)
        raise DependencyError.new(
          seed_task: @_seed_task.name,
          seed_file: @_seed_file,
          dependency: dependency,
          problem: 'expected a String or Symbol'
        )
      end

      dependency = dependency.to_s
      if dependency.empty?
        raise DependencyError.new(
          seed_task: @_seed_task.name,
          seed_file: @_seed_file,
          dependency: dependency,
          problem: 'dependency names cannot be empty'
        )
      end

      "db:seed:#{dependency}"
    end
  end
end
