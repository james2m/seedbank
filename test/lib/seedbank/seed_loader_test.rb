# test/lib/seedbank/seed_loader_test.rb
# frozen_string_literal: true

require 'test_helper'

describe Seedbank::SeedLoader do
  it 'loads common seeds before the current environment seeds' do
    events = []
    Rake.application = Rake::Application.new
    Rake::Task.define_task('db:seed:common') { events << :common }
    Rake::Task.define_task('db:seed:development') { events << :development }

    Seedbank::SeedLoader.new(environment: -> { 'development' }).load_seed

    _(events).must_equal %i[common development]
  end

  it 'loads only common seeds when the environment has no seed task' do
    events = []
    Rake.application = Rake::Application.new
    Rake::Task.define_task('db:seed:common') { events << :common }

    Seedbank::SeedLoader.new(environment: -> { 'production' }).load_seed

    _(events).must_equal %i[common]
  end

  it 'uses the current Rails environment by default' do
    events = []
    Rake.application = Rake::Application.new
    Rake::Task.define_task('db:seed:common') { events << :common }
    Rake::Task.define_task('db:seed:development') { events << :development }

    Rails.stub(:env, 'development') { Seedbank::SeedLoader.new.load_seed }

    _(events).must_equal %i[common development]
  end
end
