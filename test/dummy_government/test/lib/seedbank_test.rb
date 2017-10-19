require 'test_helper'
require 'seedbank'
require 'rake'

describe 'DummyGovernment' do
  ## right now seed files are run alphabetically by default, which means cities
  # will be run before counties and counties before states. For cities to be
  # created, however, seed files must be run in the opposite order: states,
  # counties, cities.

  describe "states seed" do

    it 'creates the right active record objects' do
    skip
      State.delete_all
      Rails.application.load_tasks
      Rake::Task['db:seed:states'].invoke
      assert_equal State.pluck(:name), %w(california nevada)
    end
  end

  describe "counties seed" do

    it 'creates the right active record objects' do

      State.destroy_all
      County.delete_all
      Rails.application.load_tasks
      Rake::Task['db:seed'].invoke
      assert_equal County.pluck(:name), %w(california nevada)
    end
  end
end
