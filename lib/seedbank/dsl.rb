module Seedbank
  module DSL

    def self.included(base)
      Rake::Task.extend(Seedbank::RenameTask)
      Rake::Application.send(:include, Seedbank::TaskManager)
    end

    def override_task(*args, &block)
      name, params, deps = Rake.application.resolve_args(args.dup)
      fq_name = Rake.application.instance_variable_get(:@scope).dup.push(name).join(':')
      new_name = "#{fq_name}:original"
      Rake::Task.rename_task(fq_name, new_name)
      Rake::Task.define_task(*args, &block)
    end

    # Creates a task namespaced in @seeds_path
    def define_seed_task(seed_file)
      relative_root = seed_file.sub(seeds_root.to_s + '/', '')
      scopes = File.dirname(relative_root).gsub(/^\./, '').split('/').unshift('seed')
      fq_name = scopes.push(File.basename(seed_file, '.seeds.rb')).join(':')

      args = Rake::Task.task_defined?('db:abort_if_pending_migrations') ? { fq_name => 'db:abort_if_pending_migrations' } : fq_name
      task = Rake::Task.define_task(args) do |seed_task|
        Seedbank::Runner.new(seed_task).module_eval(File.read(seed_file)) if File.exist?(seed_file)
      end
      task.add_description "Load the seed data from #{seed_file}"
      fq_name
    end
    
    def scope_from_seed_file(seed_file)
      pathname = Pathname.new(seed_file).relative_path_from(seeds_root)
      pathname.dirname.to_s.gsub(File::Separator, ':')
    end

    def seeds_root
      Pathname.new Seedbank.seeds_root
    end

  end
end