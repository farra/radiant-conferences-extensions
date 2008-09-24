require File.dirname(__FILE__) + '/../spec_helper'

describe Submissions do
  before(:each) do
    @submissions = Submissions.new
  end

  it "should be valid" do
    @submissions.should be_valid
  end
end
