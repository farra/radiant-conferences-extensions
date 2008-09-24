require File.dirname(__FILE__) + '/../spec_helper'

describe TagsPresentation do
  before(:each) do
    @tags_presentation = TagsPresentation.new
  end

  it "should be valid" do
    @tags_presentation.should be_valid
  end
end
