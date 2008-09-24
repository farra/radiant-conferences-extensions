require File.dirname(__FILE__) + '/../spec_helper'

describe Track do
  before(:each) do
    @track = Track.new
  end

  it "should be valid" do
    @track.should be_valid
  end
end
