require 'test_helper'
require 'seedbank'
require 'rake'

describe 'DummyGovernment' do
  ## right now seed files are run alphabetically by default, which means cities
  # will be run before counties and counties before states. For cities to be
  # created, however, seed files must be run in the opposite order: states,
  # counties, cities.

  describe "must run seed tasks in correct order" do

    it "creates counties and states" do
      %w(State Party County City).each do |model|
        eval(model).delete_all
        eval(model).count.must_equal 0
      end
      Rails.application.load_tasks
      Rake::Task['db:seed'].invoke
      assert_equal Party.pluck(:affiliation) && %w(Republican Democrat), %w(Republican Democrat)
      assert_equal State.pluck(:name), %w(california nevada)
      assert_equal County.pluck(:name), %w(mendocino douglas)
      assert_equal City.pluck(:name), %w(boonville stateline )
    end
  end
end
