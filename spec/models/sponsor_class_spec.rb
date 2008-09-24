require File.dirname(__FILE__) + '/../spec_helper'

describe SponsorClass do
  before(:each) do
    @sponsor_class = SponsorClass.new
  end

  it "should be valid" do
    @sponsor_class.should be_valid
  end
end
