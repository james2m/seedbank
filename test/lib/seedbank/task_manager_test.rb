require 'test_helper'

describe Seedbank::TaskManager do

  describe "override_task" do

    let(:task_name) { 'my_task' }

    describe "with no original version of the task exists" do

      it "appends :original to the task name" do
        task = Rake::Task.define_task(task_name)

        Rake.application.override_task(task_name)

        task.must_equal Rake.application.lookup('original', [task_name])
      end

      it "creates a new task in place of the original" do
        Rake::Task.define_task(task_name)
        task = Rake.application.override_task(task_name => [:dependency])

        task.must_be_instance_of Rake::Task
      end

      it "adds the supplied dependencies to the new task" do
        dependency = ['db:seed:dependency']

        Rake::Task.define_task(task_name)
        task = Rake.application.override_task(task_name => dependency)

        task.prerequisites.must_equal dependency
      end

      it "adds the supplied action to the new task" do
        action = proc {}
        Rake::Task.define_task(task_name)
        task = Rake.application.override_task(task_name, &action)

        task.actions.must_equal [action]
      end
    end

    describe "when the original version of the task exists" do

      let(:original_name) { [task_name, 'original'].join(':') }

      it "leaves the original task in place" do
        task     = Rake::Task.define_task(task_name)
        original = Rake::Task.define_task(original_name)
        new_task = Rake.application.override_task(task_name)

        Rake::Task[task_name].must_equal task
      end

      it "leaves the task:original task in place" do
        task     = Rake::Task.define_task(task_name)
        original = Rake::Task.define_task(original_name)
        new_task = Rake.application.override_task(task_name)

        Rake::Task[original].must_equal original
      end

      it "does not create a new task" do
        task     = Rake::Task.define_task(task_name)
        original = Rake::Task.define_task(original_name)
        new_task = Rake.application.override_task(task_name)

        new_task.must_be_nil
      end
    end
  end

  describe "rename_task" do

    let(:original_name) { 'original_name' }
    let(:new_name) { 'new_name' }

    before do
      Rake::Task.define_task(original_name)
    end

    it "changes the tasks name" do
      task = Rake::Task[original_name]
      flexmock(task).should_receive(:rename).with(new_name).once

      Rake.application.rename_task(original_name, new_name)
    end

    it "removes the original task name" do
      Rake.application.rename_task(original_name, new_name)

      Rake.application.lookup(original_name).must_be_nil
    end

    it "give the original task the new name" do
      original_task = Rake::Task[original_name]

      Rake.application.rename_task(original_name, new_name)

      Rake.application.lookup(new_name).must_equal original_task
    end
  end
end
