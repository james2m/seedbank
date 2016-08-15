module Seedbank
  class Runner

    def initialize
      @_memoized = {}
    end

    def let(name, &block)
      name = String(name)

      raise ArgumentError.new("#{name} is already defined") if respond_to?(name, true)

      __eigenclass.instance_exec(name) do |name|
        define_method(name) do
          @_memoized.fetch(name) { |key| @_memoized[key] = instance_eval(&block) }
        end
      end
    end

    def let!(name, &block)
      let(name, &block)
      send name
    end

    def evaluate(seed_task, seed_file)
      @_seed_task = seed_task
      instance_eval(File.read(seed_file), seed_file)
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
      dependencies.flatten!
      dependencies.map! { |dep| "db:seed:#{dep}"}
      dependent_task_name =  @_seed_task.name + ':body'

      if Rake::Task.task_defined?(dependent_task_name)
        dependent_task = Rake::Task[dependent_task_name]
      else
        dependent_task = Rake::Task.define_task(dependent_task_name => dependencies, &block)
      end

      dependent_task.invoke
    end

    private

    def __eigenclass
      class << self
        self
      end
    end
  end
end
