module Seedbank
  module DSL

    def self.included(base)
      Rake::Task.send(:include, Seedbank::RenameTask)
      Rake::Application.send(:include, Seedbank::TaskManager)
    end

    def override_seed_task(*args, &block)
      Rake.application.override_task(*args, &block)
    end

    def seed_task_from_file(seed_file)
      scopes  = scope_from_seed_file(seed_file)
      fq_name = scopes.push(File.basename(seed_file, '.seeds.rb')).join(':')
      args    = Rake::Task.task_defined?('db:abort_if_pending_migrations') ? { fq_name => 'db:abort_if_pending_migrations' } : { fq_name => :environment }

      define_seed_task(seed_file, args)
    end

    def glob_seed_files_matching(*args, &block)
      Dir.glob(File.join(seeds_root, *args), &block)
    end

    def define_seed_task(seed_file, *args)
      task = Rake::Task.define_task(*args) do |seed_task|
        Seedbank::Runner.new(seed_task).module_eval(File.read(seed_file)) if File.exist?(seed_file)
      end
      task.add_description "Load the seed data from #{seed_file}"
      task.name
    end

    def scope_from_seed_file(seed_file)
      dirname = Pathname.new(seed_file).dirname
      return [] if dirname == seeds_root
      relative = dirname.relative_path_from(seeds_root)
      relative.to_s.split(File::Separator)
    end

    def seeds_root
      Pathname.new Seedbank.seeds_root
    end

  end
end
