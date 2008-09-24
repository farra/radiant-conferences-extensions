require File.dirname(__FILE__) + '/../spec_helper'

describe Organization do
  before(:each) do
    @organization = Organization.new
  end

  it "should be valid" do
    @organization.should be_valid
  end
end
