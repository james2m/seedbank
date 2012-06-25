require 'rubygems'
gem 'minitest'
require 'minitest/autorun'
require "mocha"

# Configure Rails Environment
environment  = ENV["RAILS_ENV"] = 'test'
rails_root   = File.expand_path('../dummy', __FILE__)

require File.expand_path('config/environment.rb', rails_root)

Rails.backtrace_cleaner.remove_silencers!

Seedbank.seeds_root = File.expand_path('dummy/db/seeds', __FILE__)

