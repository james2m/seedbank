require 'test_helper'

describe County do

  subject { County }

  specify "associations" do

    must_belong_to(:state)
    must_belong_to(:party)
    must_have_many(:cities)
  end
end
