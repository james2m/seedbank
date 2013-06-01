require 'test_helper'

describe Seedbank::Runner do

  before do
    flexmock(FakeModel)
  end

  describe "seeds with dependency" do

    subject { Rake::Task['db:seed:dependent'] }

    it "runs the dependencies in order" do
      FakeModel.should_receive(:seed).with('dependency').once.ordered
      FakeModel.should_receive(:seed).with('dependent').once.ordered

      subject.invoke
    end
  end

  describe "seeds with multiple dependencies" do

    subject { Rake::Task['db:seed:dependent_on_several'] }

    it "runs the dependencies in order" do
      FakeModel.should_receive(:seed).with('dependency').once.ordered
      FakeModel.should_receive(:seed).with('dependency2').once.ordered
      FakeModel.should_receive(:seed).with('dependent on several').once.ordered

      subject.invoke
    end
  end

  describe "seeds with nested dependencies" do

    subject { Rake::Task['db:seed:dependent_on_nested'] }

    it "runs all dependencies in order" do
      FakeModel.should_receive(:seed).with('dependency').once.ordered
      FakeModel.should_receive(:seed).with('dependent').once.ordered
      FakeModel.should_receive(:seed).with('dependency2').once.ordered
      FakeModel.should_receive(:seed).with('dependent on nested').once.ordered

      subject.invoke
    end

  end

  describe "after with no block given" do

    subject { Rake::Task['db:seed:no_block'] }

    it "runs the dependencies" do
      FakeModel.should_receive(:seed).with('dependency').once.ordered

      subject.invoke
    end
  end

  describe "let" do

    it "does something" do

    end
  end
end
