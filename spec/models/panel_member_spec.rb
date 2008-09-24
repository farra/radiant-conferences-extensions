require File.dirname(__FILE__) + '/../spec_helper'

describe PanelMember do
  before(:each) do
    @panel_member = PanelMember.new
  end

  it "should be valid" do
    @panel_member.should be_valid
  end
end
