require File.dirname(__FILE__) + '/../../../spec_helper'

describe Admin::Con::ScheduleHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the Admin::Con::ScheduleHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(Admin::Con::ScheduleHelper)
  end
  
end
