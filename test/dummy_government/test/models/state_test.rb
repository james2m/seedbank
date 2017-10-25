require 'test_helper'

describe State do

  subject { State }

  specify "associations" do

    must_belong_to :party

    must_have_many(:counties)
    must_have_many(:cities)
  end
end
