Gem::Specification.new do |s|
  s.name = %q{seedbank}
  s.version = "0.0.7"
  s.date = %q{2011-03-20}

  s.required_rubygems_version = Gem::Requirement.new(">=1.2.0") if s.respond_to?(:required_rubygems_version=)
  s.rubygems_version = %q{1.3.5}

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

  s.files = Dir.glob('**/*') - Dir.glob('seedbank*.gem')
  s.require_paths = ["lib"]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = [
    "MIT-LICENSE",
    "README.md"
  ]

  s.test_files = Dir.glob('test/**/*')
  s.add_development_dependency('test-unit')
  
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

