Gem::Specification.new do |s|
  s.name = %q{seedbank}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">=1.2.0") if s.respond_to?(:required_rubygems_version=)
  s.authors = ["James McCarthy"]
  s.date = %q{2011-03-20}
  s.description = %q{
    Extends Rails seeds to split out complex seeds into multiple 
    files and lets each environment have it's own seeds.
  }
  s.email = %q{james2mccarthy@gmail.com}
  s.extra_rdoc_files = [
    "MIT-LICENSE",
    "README.md"
  ]
  s.files = Dir.glob('**/*') - Dir.glob('seedbank*.gem')
  s.homepage = %q{http://github.com/james2m/seedbank}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{
    Extends Rails seeds to split out complex seeds into their own file 
    and have different seeds for each environment.
  }
  s.test_files = Dir.glob('test/**/*')

  s.add_development_dependency('test-unit')
end

