# frozen_string_literal: true
require 'test_helper'

describe Seedbank::Runner do
  describe 'seeds with dependency' do
    subject { Rake::Task['db:seed:dependent'] }

    it 'runs the dependencies in order' do
      FakeModel.expect :seed, true, ['dependency']
      FakeModel.expect :seed, true, ['dependent']

      subject.invoke

      FakeModel.verify
    end

    it 'executes the body of the dependencies exactly once per invocation' do
      FakeModel.expect :seed, true, ['dependency']
      FakeModel.expect :seed, true, ['dependent']
      FakeModel.expect :seed, true, ['dependency']
      FakeModel.expect :seed, true, ['dependent']

      subject.invoke

      # Allow all tasks to be re-executed, including dependencies
      Rake.application.tasks.each(&:reenable)

      subject.invoke

      FakeModel.verify
    end
  end

  describe 'seeds with multiple dependencies' do
    subject { Rake::Task['db:seed:dependent_on_several'] }

    it 'runs the dependencies in order' do
      FakeModel.expect :seed, true, ['dependency']
      FakeModel.expect :seed, true, ['dependency2']
      FakeModel.expect :seed, true, ['dependent on several']

      subject.invoke

      FakeModel.verify
    end
  end

  describe 'seeds with nested dependencies' do
    subject { Rake::Task['db:seed:dependent_on_nested'] }

    it 'runs all dependencies in order' do
      FakeModel.expect :seed, true, ['dependency']
      FakeModel.expect :seed, true, ['dependent']
      FakeModel.expect :seed, true, ['dependency2']
      FakeModel.expect :seed, true, ['dependent on nested']

      subject.invoke

      FakeModel.verify
    end
  end

  describe 'after with no block given' do
    subject { Rake::Task['db:seed:no_block'] }

    it 'runs the dependencies' do
      FakeModel.expect :seed, true, ['dependency']

      subject.invoke

      FakeModel.verify
    end
  end

  describe 'let' do
    describe 'evaluates dependencies in order' do
      subject { Rake::Task['db:seed:reference_memos'] }

      it 'runs the dependencies in order' do
        FakeModel.expect :seed, true, ['with_inline_memo']
        FakeModel.expect :seed, true, ['with_block_memo']
        FakeModel.expect :calling_let, true, ['BLOCK_LET']
        FakeModel.expect :calling_let, true, ['INLINE_LET']

        def FakeModel.calling_let!(*_args); end

        def FakeModel.calling_method(*_args); end

        subject.invoke

        FakeModel.verify
      end
    end

    describe 'a previously defined method' do
      let(:runner) { Seedbank::Runner.new }

      before { runner.let(:existing) {} }

      %w[existing let! let evaluate after extend].each do |name|
        it 'raises ArgumentError' do
          assert_raises(ArgumentError, Regexp.new(name)) do
            runner.let(name)
          end
        end
      end
    end
  end

  # TODO: These don't really test in order. Maybe swap in rspec_mocks
  describe 'let!' do
    describe 'evaluates dependencies in order' do
      subject { Rake::Task['db:seed:reference_memos'] }

      it 'runs the dependencies in order' do
        FakeModel.expect :seed, true, ['with_inline_memo']
        FakeModel.expect :calling_let!, true, ['INLINE_LET!']
        FakeModel.expect :seed, true, ['with_block_memo']
        FakeModel.expect :calling_let!, true, ['BLOCK_LET!']
        FakeModel.expect :calling_let, true, ['BLOCK_LET']
        FakeModel.expect :calling_let, true, ['INLINE_LET']
        FakeModel.expect :calling_method, true, ['inline_method']

        subject.invoke

        FakeModel.verify
      end
    end
  end

  # TODO: This doesn't do anything more than the above except for
  # isolating the inline method call. Would be better served by it's
  # own seeds in isolation.
  describe 'defining an inline method' do
    describe 'evaluates dependencies in order' do
      subject { Rake::Task['db:seed:reference_memos'] }

      it 'runs the dependencies in order' do
        FakeModel.expect :calling_method, true, ['inline_method']

        def FakeModel.seed(*_args); end

        def FakeModel.calling_let(*_args); end

        def FakeModel.calling_let!(*_args); end

        subject.invoke

        FakeModel.verify
      end
    end
  end
end
