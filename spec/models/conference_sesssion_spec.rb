require File.dirname(__FILE__) + '/../spec_helper'

describe ConferenceSesssion do
  before(:each) do
    @conference_sesssion = ConferenceSesssion.new
  end

  it "should be valid" do
    @conference_sesssion.should be_valid
  end
end
