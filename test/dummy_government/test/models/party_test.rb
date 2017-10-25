require "test_helper"

describe Party do

  subject { Party }

  specify "associations" do

    must_have_many :states
    must_have_many :counties
    must_have_many :cities
  end
end
