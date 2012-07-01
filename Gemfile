source "http://rubygems.org"

# Specify your gem's dependencies in seedbank.gemspec
gemspec

group :test do
  gem 'rake'
end

# for CRuby, Rubinius, including Windows and RubyInstaller
gem "sqlite3", :platform => [:ruby, :mswin, :mingw]

# for JRuby
gem "jdbc-sqlite3", :platform => :jruby