require File.dirname(__FILE__) + '/../spec_helper'

describe PresentationCapacity do
  before(:each) do
    @presentation_capacity = PresentationCapacity.new
  end

  it "should be valid" do
    @presentation_capacity.should be_valid
  end
end
