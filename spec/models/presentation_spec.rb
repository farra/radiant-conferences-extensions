require File.dirname(__FILE__) + '/../spec_helper'

describe Presentation do
  before(:each) do
    @presentation = Presentation.new
  end

  it "should be valid" do
    @presentation.should be_valid
  end
end
