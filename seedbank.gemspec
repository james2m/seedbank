# seedbank.gemspec
# frozen_string_literal: true

require_relative 'lib/seedbank/version'

Gem::Specification.new do |spec|
  spec.name = 'seedbank'
  spec.version = Seedbank::VERSION
  spec.authors = ['James McCarthy']
  spec.email = ['james2mccarthy@gmail.com']

  spec.summary = 'Organize seed data for Ruby and Rails applications.'
  spec.description = <<~DESCRIPTION
    Seedbank adds structured Rake tasks for common and environment-specific
    seed data, including explicit dependencies between seed files.
  DESCRIPTION
  spec.homepage = 'https://github.com/scarver2/seedbank'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.1'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/scarver2/seedbank/issues',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/scarver2/seedbank'
  }

  spec.files = Dir['lib/**/*', 'MIT-LICENSE', 'README.md'].select { |file| File.file?(file) }.sort
  spec.require_paths = ['lib']

  spec.add_dependency 'rake', '>= 10.0'
end
