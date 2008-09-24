require File.dirname(__FILE__) + '/../spec_helper'

describe PresentationsTag do
  before(:each) do
    @presentations_tag = PresentationsTag.new
  end

  it "should be valid" do
    @presentations_tag.should be_valid
  end
end
