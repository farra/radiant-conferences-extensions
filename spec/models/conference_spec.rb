require File.dirname(__FILE__) + '/../spec_helper'

describe Conference do
  before(:each) do
    @conference = Conference.new
  end

  it "should be valid" do
    @conference.should be_valid
  end
end
