# test/lib/seedbank_test.rb
# frozen_string_literal: true

require 'test_helper'

describe Seedbank do
  before do
    @configuration = configuration_variables.to_h do |variable|
      [variable, Seedbank.instance_variable_get(variable)]
    end
    configuration_variables.each { |variable| Seedbank.remove_instance_variable(variable) if Seedbank.instance_variable_defined?(variable) }
  end

  after do
    configuration_variables.each { |variable| Seedbank.remove_instance_variable(variable) if Seedbank.instance_variable_defined?(variable) }
    @configuration.each { |variable, value| Seedbank.instance_variable_set(variable, value) }
  end

  def configuration_variables
    %i[@application_root @matcher @nesting @seeds_root]
  end

  it 'provides conventional defaults' do
    _(Seedbank.application_root).must_equal Pathname.new(Rake.application.original_dir)
    _(Seedbank.matcher).must_equal '*.seeds.rb'
    _(Seedbank.nesting).must_equal 2
    _(Seedbank.seeds_root).must_equal File.join(Seedbank.application_root, 'db', 'seeds')
  end

  it 'uses explicit configuration' do
    Seedbank.application_root = Pathname.new('/tmp/seedbank-app')
    Seedbank.matcher = '*.seed.rb'
    Seedbank.nesting = 4
    Seedbank.seeds_root = '/tmp/seedbank-seeds'

    _(Seedbank.application_root).must_equal Pathname.new('/tmp/seedbank-app')
    _(Seedbank.matcher).must_equal '*.seed.rb'
    _(Seedbank.nesting).must_equal 4
    _(Seedbank.seeds_root).must_equal '/tmp/seedbank-seeds'
  end
end
