require 'test_helper'

describe Seedbank::Runner do

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

    describe "evaluates dependencies in order" do

      subject { Rake::Task['db:seed:reference_memos'] }

      it "runs the dependencies in order" do
        FakeModel.expect :seed, true, ['with_inline_memo']
        FakeModel.expect :seed, true, ['with_block_memo']
        FakeModel.expect :calling_let, true, ['BLOCK_LET']
        FakeModel.expect :calling_let, true, ['INLINE_LET']

        def FakeModel.calling_let!(*args); end

        subject.invoke

        FakeModel.verify
      end
    end

    describe "a previously defined method" do

      let(:runner) { Seedbank::Runner.new }

      before { runner.let(:existing) {} }

      %w(__eigenclass existing let let evaluate after).each do |name|
        it 'raises ArgumentError' do
          assert_raises(ArgumentError, Regexp.new(name)) do
            runner.let(name)
          end
        end
      end
    end

  end

  describe "let!" do

    describe "evaluates dependencies in order" do

      subject { Rake::Task['db:seed:reference_memos'] }

      it "runs the dependencies in order" do
        FakeModel.expect :calling_let!, true, ['INLINE_LET!']
        FakeModel.expect :calling_let!, true, ['BLOCK_LET!']

        def FakeModel.seed(*args); end
        def FakeModel.calling_let(*args); end

        subject.invoke

        FakeModel.verify
      end
    end

  end
end
