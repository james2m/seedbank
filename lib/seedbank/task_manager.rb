module Seedbank
  module TaskManager

    def rename_task(fq_name, new_name)
      @tasks[new_name] = @tasks.delete(fq_name)
      @tasks[new_name].instance_variable_set('@name', new_name)
    end

  end
end