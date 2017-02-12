# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'
require 'rdoc/task'

desc 'Test the seedbank gem.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/lib/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the seedbank gem.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Seedbank'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task default: ['test']
