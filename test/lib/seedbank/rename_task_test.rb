require 'test_helper'

describe Seedbank::RenameTask do

  describe "rename" do

    let(:original_name) { 'original_name' }
    let(:new_name) { 'new_name' }

    subject { Rake::Task.define_task(original_name) }

    before { subject.rename(new_name) }

    it "changes the tasks name" do
      subject.name.must_equal new_name
    end

  end
end
