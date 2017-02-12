# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seedbank/version'

Gem::Specification.new do |spec|
  spec.name        = 'seedbank'
  spec.version     = Seedbank::VERSION
  spec.authors     = ['James McCarthy']
  spec.email       = ['[james2mccarthy@gmail.com']
  spec.summary     = 'Extends Rails seeds to split complex seeds and have different seeds for each environment.'
  spec.description = spec.summary
  spec.date        = `git log -1 --format="%cd" --date=short lib/seedbank/version.rb`
  spec.homepage    = 'http://github.com/james2m/seedbank'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.rdoc_options     = ['--charset=UTF-8']
  spec.extra_rdoc_files = ['MIT-LICENSE', 'README.md']

  spec.add_dependency 'rake', '>= 10.0'

  spec.add_development_dependency 'bundler',  '~> 1.11'
  spec.add_development_dependency 'rails',    '~> 4.2'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'm',        '~> 1.5'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'byebug'
end
