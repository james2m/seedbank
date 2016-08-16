# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "seedbank/version"

Gem::Specification.new do |spec|
  spec.name        = %q{seedbank}
  spec.version     = Seedbank::VERSION
  spec.authors     = ["James McCarthy"]
  spec.email       = ['[james2mccarthy@gmail.com']
  spec.summary     = %q{Extends Rails seeds to split complex seeds and have different seeds for each environment.}
  spec.description = spec.summary
  spec.date        = `git log -1 --format="%cd" --date=short lib/seedbank/version.rb`
  spec.homepage    = %q{http://github.com/james2m/seedbank}
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.rdoc_options     = ['--charset=UTF-8']
  spec.extra_rdoc_files = ['MIT-LICENSE', 'README.md']

  spec.add_development_dependency 'bundler',  '~> 1.12'
  spec.add_development_dependency 'rails',    '~> 3.2'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'm',        '~> 1.5'
end

