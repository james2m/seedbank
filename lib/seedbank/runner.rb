module Seedbank
  class Runner < Module
  
    def initialize(task)
      @task = task
      super()
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
      dependent_task_name =  @task.name + ':body'
      dependent_task = Rake::Task.define_task(dependent_task_name => dependencies, &block)
      dependent_task.invoke
    end
  
  end
end
