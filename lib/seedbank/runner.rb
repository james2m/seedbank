# frozen_string_literal: true
module Seedbank
  class Runner
    def initialize
      @_memoized = {}
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
      depends_on = dependencies.flat_map { |dep| "db:seed:#{dep}" }
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
      @_seed_task = seed_task
      instance_eval(File.read(seed_file), seed_file)
    end
  end
end
