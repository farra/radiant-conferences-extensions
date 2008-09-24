require File.dirname(__FILE__) + '/../spec_helper'

describe SessionType do
  before(:each) do
    @session_type = SessionType.new
  end

  it "should be valid" do
    @session_type.should be_valid
  end
end
