require 'test_helper'

describe Seedbank::Runner do
  
  describe "seeds with dependency" do

    subject { Rake::Task['db:seed:dependent'] }
    
    it "runs the dependent seed" do
      Post.expects(:create).with(:title => 'title').returns(true)
      subject.invoke
    end
    
    it "runs the dependency" do
      User.expects(:create).with(:email => 'user@example.com').returns(true)
      subject.invoke
    end

  end
end
