# test/lib/seedbank/version_test.rb
# frozen_string_literal: true

require 'test_helper'

describe Seedbank::VERSION do
  it 'uses a semantic version' do
    _(Gem::Version.new(Seedbank::VERSION)).must_be_instance_of Gem::Version
    _(Seedbank::VERSION).must_match(
      /\A\d+\.\d+\.\d+(?:[.-][0-9A-Za-z]+(?:[.-][0-9A-Za-z]+)*)?(?:\+[0-9A-Za-z]+(?:[.-][0-9A-Za-z]+)*)?\z/
    )
  end
end
