require File.dirname(__FILE__) + '/../spec_helper'

describe PresentationType do
  before(:each) do
    @presentation_type = PresentationType.new
  end

  it "should be valid" do
    @presentation_type.should be_valid
  end
end
