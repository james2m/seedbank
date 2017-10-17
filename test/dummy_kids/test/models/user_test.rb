require 'test_helper'
require 'rake'
require 'seedbank'

include Seedbank

describe User do

  subject { User }

  specify "associations" do

    must_have_many(:children)
    must_have_many(:grand_children)
    must_have_many(:great_grand_children)

    must_belong_to(:father)
    must_belong_to(:mother)
  end
end
