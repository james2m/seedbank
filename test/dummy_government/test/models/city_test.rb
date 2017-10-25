require 'test_helper'

describe City do

  subject { City }

  specify "associations" do

    must_belong_to(:county)
    must_belong_to :party
  end

  describe "dummy associations must work correctly" do

    setup do
      @nevada = states(:nevada)
      @california = states(:california)
      @washoe = counties(:washoe)
      @mendocino = counties(:mendocino)
      @reno = cities(:reno)
      @boonville = cities(:boonville)
    end

    describe "a state must" do

      specify "have many counties" do
        assert_includes @nevada.counties, @washoe
        assert_includes @california.counties, @mendocino
      end

      specify "have many cities" do
        assert_includes @nevada.cities, @reno
        assert_includes @california.cities, @boonville
      end
    end

    describe "a county must" do

      specify "have many cities" do
        assert_includes @washoe.cities, @reno
        assert_includes @mendocino.cities, @boonville
      end

      specify "belong to a state" do
        assert_equal @washoe.state, @nevada
        assert_equal @mendocino.state, @california
      end
    end

    describe "a city must" do

      describe "belong to" do

        specify "a county" do
          assert_equal @reno.county, @washoe
          assert_equal @boonville.county, @mendocino
        end

        specify "a state through delegation" do
          assert_equal @reno.county.state, @nevada
          assert_equal @boonville.county.state, @california
          assert_equal @reno.state, @nevada
          assert_equal @boonville.state, @california
        end
      end
    end
  end
end
