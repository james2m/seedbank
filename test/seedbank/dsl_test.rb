require 'test_helper'

describe Seedbank::DSL do

  describe "scope_from_seed_file" do

    it "is added to the namesapce" do
      ns = Rake.application.in_namespace(:seedy) { self }
      
      ns.must_respond_to :scope_from_seed_file
    end

    describe "with an environment directory" do
      
      let(:seed_file) { File.expand_path('development/users.seeds.rb', Seedbank.seeds_root) }
      let(:seed_namespace) { 'development' }
      
      subject {Seedbank::DSL.scope_from_seed_file seed_file  }
      
      it "returns the enviroment scope" do
        subject.must_equal seed_namespace
      end
    end

    describe "with a nested directory" do
      
      let(:seed_file) { File.expand_path('development/shared/accounts.seeds.rb', Seedbank.seeds_root) }
      let(:seed_namespace) { 'development:shared' }
      
      subject {Seedbank::DSL.scope_from_seed_file seed_file  }
      
      it "returns the nested scope" do
        subject.must_equal seed_namespace
      end
    end
  end

end
