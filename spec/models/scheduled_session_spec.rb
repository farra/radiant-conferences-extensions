require File.dirname(__FILE__) + '/../spec_helper'

describe ScheduledSession do
  before(:each) do
    @scheduled_session = ScheduledSession.new
  end

  it "should be valid" do
    @scheduled_session.should be_valid
  end
end
