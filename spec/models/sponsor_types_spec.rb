require File.dirname(__FILE__) + '/../spec_helper'

describe SponsorTypes do
  before(:each) do
    @sponsor_types = SponsorTypes.new
  end

  it "should be valid" do
    @sponsor_types.should be_valid
  end
end
