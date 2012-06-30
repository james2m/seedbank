module Seedbank
  class Runner < Module
  
    def initialize(task)
      @task = task
      super()
    end
  
    def after(*deps, &block)
      dependencies = deps.flatten.map { |dep| "db:seed:#{dep}"}
      dependent_task_name =  @task.name + ':body'
      dependent_task = Rake::Task.define_task(dependent_task_name => dependencies, &block)
      dependent_task.invoke
    end
  
  end
end
