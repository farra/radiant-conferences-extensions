require File.dirname(__FILE__) + '/../spec_helper'

describe Sponsor do
  before(:each) do
    @sponsor = Sponsor.new
  end

  it "should be valid" do
    @sponsor.should be_valid
  end
end
