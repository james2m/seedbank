source "http://rubygems.org"

# Specify your gem's dependencies in seedbank.gemspec
gemspec

group :test do
  gem 'rake'
  gem 'byebug'
end

# for CRuby, Rubinius, including Windows and RubyInstaller
gem "sqlite3", :platform => [:ruby, :mswin, :mingw]

# for JRuby
gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby
