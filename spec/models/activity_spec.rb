require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do
  before(:each) do
    @model = @activity = Activity.new(:end_time => 3.minutes.from_now, :start_time => Time.now)
  end

  it "should be valid" do
    @activity.should be_valid
  end
  
  it_should_behave_like 'clearing cache after save'
end
