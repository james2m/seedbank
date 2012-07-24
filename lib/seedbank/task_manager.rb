module Seedbank
  module TaskManager

    def override_task(*args, &block)
      name, params, deps = resolve_args(args.dup)
      fq_name = current_scope.push(name).join(':')
      new_name = "#{fq_name}:original"
      unless Rake::Task.task_defined?(new_name)
        rename_task(fq_name, new_name)
        define_task(Rake::Task, *args, &block)
      end
    end

    def rename_task(fq_name, new_name)
      task = @tasks.delete(fq_name)
      task.rename(new_name)
      @tasks[new_name] = task
    end

  end
end