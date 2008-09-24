require File.dirname(__FILE__) + '/../spec_helper'

describe Presenter do
  before(:each) do
    @presenter = Presenter.new
  end

  it "should be valid" do
    @presenter.should be_valid
  end
end
