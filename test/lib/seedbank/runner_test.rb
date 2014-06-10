require 'test_helper'

describe Seedbank::Runner do

  before do
    Object.const_set :FakeModel, MiniTest::Mock.new
  end

  describe "seeds with dependency" do

    subject { Rake::Task['db:seed:dependent'] }

    it "runs the dependencies in order" do
      FakeModel.expect :seed, true, ['dependency']
      FakeModel.expect :seed, true, ['dependent']

      subject.invoke

      FakeModel.verify
    end
  end

  describe "seeds with multiple dependencies" do

    subject { Rake::Task['db:seed:dependent_on_several'] }

    it "runs the dependencies in order" do
      FakeModel.expect :seed, true, ['dependency']
      FakeModel.expect :seed, true, ['dependency2']
      FakeModel.expect :seed, true, ['dependent on several']

      subject.invoke

      FakeModel.verify
    end
  end

  describe "seeds with nested dependencies" do

    subject { Rake::Task['db:seed:dependent_on_nested'] }

    it "runs all dependencies in order" do
      FakeModel.expect :seed, true, ['dependency']
      FakeModel.expect :seed, true, ['dependent']
      FakeModel.expect :seed, true, ['dependency2']
      FakeModel.expect :seed, true, ['dependent on nested']

      subject.invoke

      FakeModel.verify
    end

  end

  describe "after with no block given" do

    subject { Rake::Task['db:seed:no_block'] }

    it "runs the dependencies" do
      FakeModel.expect :seed, true, ['dependency']

      subject.invoke

      FakeModel.verify
    end
  end

  describe "let" do

    it "does something" do

    end
  end
end
