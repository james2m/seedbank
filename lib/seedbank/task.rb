module Seedbank
  module Task

    def rename_task(fq_name, new_name)
      Rake.application.rename_task(fq_name, new_name)
    end

  end
end