require File.dirname(__FILE__) + '/../spec_helper'

describe Person do
  before(:each) do
    @person = Person.new
    @person.name = "Someone"
  end

  it "should be valid" do
    @person.should be_valid
  end

  it "should reject url www.example.com" do
    @person.url = "www.example.com"
    @person.should_not be_valid
  end

  it "should accept url http://www.example.com" do
    @person.url = "www.example.com"
    @person.should_not be_valid
  end

  it "should accept email you@example.com" do
    @person.email = "you@example.com"
    @person.should be_valid
  end

  it "should reject email you-example.com" do
    @person.email = "you-example.com"
    @person.should_not be_valid
  end

end
