# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "seedbank/version"

Gem::Specification.new do |s|
  s.name = %q{seedbank}
  s.version = Seedbank::VERSION
  s.date = `git log -1 --format="%cd" --date=short lib/seedbank/version.rb`

  s.required_rubygems_version = Gem::Requirement.new(">=1.2.0") if s.respond_to?(:required_rubygems_version=)
  s.rubygems_version = %q{1.3.5}
  s.license = "MIT"

  s.authors = ["James McCarthy"]
  s.email = %q{james2mccarthy@gmail.com}
  s.homepage = %q{http://github.com/james2m/seedbank}
  s.summary = %q{
    Extends Rails seeds to split out complex seeds into their own file
    and have different seeds for each environment.
  }
  s.description = %q{
    Extends Rails seeds to split out complex seeds into multiple
    files and lets each environment have it's own seeds.
  }
  s.license = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = [
    "MIT-LICENSE",
    "README.md"
  ]

  s.add_development_dependency "minitest", "~> 3.2"
  s.add_development_dependency "flexmock"
  s.add_development_dependency "rails", "~> 3.2.6"
  
  s.post_install_message = %q{
  ================================================================================

  Rails 2.x
  ---------
  If you are using Seedbank with Rails 2.x you will need to place the following at 
  the end of your Rakefile so Rubygems can load the seedbank tasks;

    require 'seedbank'
    Seedbank.load_tasks if defined?(Seedbank)

  Rails 3.x
  ---------
  Your work here is done!

  ================================================================================
  } 
end

