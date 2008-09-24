require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do

  #Delete these examples and add some real ones
  it "should use DashboardController" do
    controller.should be_an_instance_of(DashboardController)
  end


  it "GET 'admin/con/dashboard' should be successful" do
    get 'admin/con/dashboard'
    response.should be_success
  end
end
