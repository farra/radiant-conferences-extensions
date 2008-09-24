require File.dirname(__FILE__) + '/../spec_helper'

describe Capacity do
  before(:each) do
    @capacity = Capacity.new
  end

  it "should be valid" do
    @capacity.should be_valid
  end
end
