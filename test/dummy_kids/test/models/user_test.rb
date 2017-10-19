require 'test_helper'
require 'rake'
require 'seedbank'

include Seedbank

describe User do

  subject { User }

  specify "associations" do

    must_belong_to(:father)

    # must_have_many(:children)
    # must_have_many(:grandchildren)
    # must_have_many(:greatgrandchildren)
  end

  specify "requires presence of mother and father" do

    @fred = users(:great_grandfather)
    @kurt = users(:grandfather)
    @doug = users(:father)
    @rohan = users(:son)

    assert_equal @kurt, @doug.father
    assert_equal @doug, @rohan.father
    assert_equal @rohan, @doug.sons.first
    assert_equal @rohan, @kurt.grandsons.first


    # child = users(:ella, father_id: father.id, mother_id: mother.id)
    # mother.name.must_equal "Sarah Jane"



  end
end
