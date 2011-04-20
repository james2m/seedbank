module Seedbank
  module DSL

    def override_task(*args, &block)
      name, params, deps = Rake.application.resolve_args(args.dup)
      fq_name = Rake.application.instance_variable_get(:@scope).dup.push(name).join(':')
      new_name = "#{fq_name}:original"
      Rake::Task.rename_task(fq_name, new_name)
      Rake::Task.define_task(*args, &block)
    end

    # Creates a task namespaced in @seeds_path
    def define_seed_task(seed_file)
      relative_root = seed_file.sub(seeds_root + '/', '')
      scopes = File.dirname(relative_root).gsub(/^\./, '').split('/').unshift('seed')
      fq_name = scopes.push(File.basename(seed_file, '.seeds.rb')).join(':')

      args = { fq_name => 'db:abort_if_pending_migrations' }
      task = Rake::Task.define_task(args) { load(seed_file) if File.exist?(seed_file) }
      task.add_description "Load the seed data from #{seed_file}"
      fq_name
    end

    def seeds_root
      Seedbank.seeds_root
    end

  end
end